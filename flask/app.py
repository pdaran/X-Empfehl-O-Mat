import os
import sys
import psycopg2
from flask import Flask, jsonify, redirect, url_for, request
import pandas as pd
import pandas.io.sql as sqlio
from sklearn.metrics import pairwise_distances

app = Flask(__name__)

db_name = 'x_empfehl_development'
db_username = os.getenv("POSTGRES_USER")
db_password = os.getenv("POSTGRES_PASSWORD")


def get_db_connection():
    conn = psycopg2.connect(host='empfehl-db',
                            port=5432,
                            database=db_name,
                            user=db_username,
                            password=db_password)
    return conn


@app.route('/')
def hello_world():
    return '<h1> HELLO WORLD </h1>'


@app.route('/users')
def get_users():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT * FROM users;')
    users = cur.fetchall()
    cur.close()
    conn.close()
    return jsonify(users)


@app.route('/recommend', methods=['POST', 'GET'])
def get_recommendation():
    if request.method == 'POST':
        customer_id = int(request.form['id'])
        conn = get_db_connection()
        sql = 'SELECT "customer_id","like","product_id" FROM likes;'
        customer_likes_matrix = sqlio.read_sql_query(sql, conn)
        conn.close()

        #print(customer_likes_matrix, file=sys.stderr)

        customer_likes_matrix = customer_likes_matrix.pivot_table(index='customer_id',columns='product_id')

        #print(customer_likes_matrix, file=sys.stderr)

        customer_likes_matrix = customer_likes_matrix.fillna(0)
        #print(customer_likes_matrix, file=sys.stderr)

        customer_similarity = 1 - pairwise_distances(customer_likes_matrix, metric='cosine')
        customer_similarity = pd.DataFrame(customer_similarity, index=customer_likes_matrix.index,
                                           columns=customer_likes_matrix.index)

        target_customer = customer_id

        similar_customers = customer_similarity[target_customer].sort_values(ascending = False)[1:]

        similar_customers = similar_customers[similar_customers > 0]

        #print(similar_customers, file=sys.stderr)

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
        # recommendations.index = product.id
        recommendations = recommendations.groupby(recommendations.index).sum().sort_values(ascending=False)

        print(type(recommendations), file=sys.stderr)


        # cur = conn.cursor()
        # cur.execute('SELECT * FROM products ORDER BY RANDOM() LIMIT 5;')
        # products = cur.fetchall()
        # cur.close()
        # #print(products, file=sys.stderr)  # Printing to console

        # Dataframe target_customer (customer_id) -> like (product_id)
        # df_targetCustomer_likedProductcs = pd.DataFrame(data)
        #print(customer_similarity, file=sys.stderr)

        return recommendations.to_json()
    else:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('SELECT * FROM products ORDER BY RANDOM() LIMIT 5;')
        products = cur.fetchall()
        cur.close()
        conn.close()
        # #print(products, file=sys.stderr)  # Printing to console
        id_list = []
        # Extract only IDs from Products
        for product in products:
            id_list.append(product[0])
        return jsonify(id_list)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
