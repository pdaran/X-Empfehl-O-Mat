import os
import sys
from flask import Flask, jsonify, redirect, url_for, request
import pandas as pd
import pandas.io.sql as sqlio
from sklearn.metrics import pairwise_distances
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

app = Flask(__name__)

db_username = os.getenv("POSTGRES_USER")
db_password = os.getenv("POSTGRES_PASSWORD")
db_hostname = 'empfehl-db'
db_port = '5432'
db_name = 'x_empfehl_development'

# Number of product recommendations
recommendation_amount = 3

app.config['SQLALCHEMY_DATABASE_URI'] = f"postgresql://{db_username}:{db_password}@{db_hostname}:{db_port}/{db_name}"
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True

db.init_app(app)

@app.route('/')
def hello_world():
    return '<h1> HELLO WORLD </h1>'

@app.route('/recommend', methods=['POST', 'GET'])
def get_recommendation():
    if request.method == 'POST':
        customer_id = int(request.form['customer_id'])
        category_id = str(request.form['category_id'])
    else:
        customer_id = int(request.args.get('customer_id'))
        category_id = str(request.args.get('category_id'))

    print("category:" + str(category_id), file=sys.stderr)

    engine = db.engine
    with engine.begin() as conn:
        sql = '''SELECT "customer_id","like","product_id" FROM likes INNER JOIN products p on p.id = likes.product_id 
        WHERE p.category_id = '{}';'''.format(category_id)
        customer_likes_matrix = sqlio.read_sql_query(sql, conn)

    # Filter Series for values that equal to customer id and then test for length
    # This is because "if customer_id not in customer_likes_matrix["customer_id"]:" returned wrong values ????
    customer_likes_matrix_customer = customer_likes_matrix["customer_id"][customer_likes_matrix["customer_id"].isin([customer_id])]
    if customer_likes_matrix_customer.size == 0:
        return f"Customer with id {customer_id} has not made any recommendations in the selected category", 404

    target_customer = customer_id

    liked_products = customer_likes_matrix[customer_likes_matrix['customer_id'] == target_customer]

    liked_products_list = liked_products['product_id'].to_list()

    customer_likes_matrix = customer_likes_matrix.pivot_table(index='customer_id', columns='product_id')

    customer_likes_matrix = customer_likes_matrix.fillna(0)

    customer_similarity = 1 - pairwise_distances(customer_likes_matrix, metric='cosine')
    customer_similarity = pd.DataFrame(customer_similarity, index=customer_likes_matrix.index,
                                       columns=customer_likes_matrix.index)

    similar_customers = customer_similarity[target_customer].sort_values(ascending=False)[1:]

    similar_customers = similar_customers[similar_customers > 0]

    # print(similar_customers, file=sys.stderr)

    recommendations = pd.Series()

    # Iterate over the index of similar_users
    for i in similar_customers.index:
        # Korrelation (Ähnlichkeit) vom "similar_user[i]" zu target_user speichern
        similarity = similar_customers.loc[i]

        # Gelikete Produkte vom similar_user[i]
        similar_customers_preferences = customer_likes_matrix.loc[i]
        liked_products = similar_customers_preferences[similar_customers_preferences > 0]

        # Verteilung der gelikten Produkte mit Korrelation (Ähnlichkeit) gewichten
        weighted_liked_products = liked_products * similarity

        # Gewichteten Wert zu Produkten hinzufügen
        recommendations = pd.concat([recommendations, weighted_liked_products])

    # Gruppieren nach product_id und Summe der Gewichte berechnen
    recommendations = recommendations.groupby(recommendations.index).sum().sort_values(ascending=False)

    # Limit number of recommendations
    recommendations = recommendations[:recommendation_amount]

    # To dictionary
    recommendations = recommendations.to_dict()

    # create simple list of product id's
    recommendations_simple = []
    for item in recommendations:
        recommendations_simple.append(item[1])

    filtered_recommendation = []

    for item in recommendations_simple:
        if item not in liked_products_list:
            filtered_recommendation.append(item)

    print(filtered_recommendation, file=sys.stderr)

    return jsonify(filtered_recommendation)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
