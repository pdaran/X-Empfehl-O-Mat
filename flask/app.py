import os
import sys
import psycopg2
from flask import Flask, jsonify, redirect, url_for, request
import pandas as pd
import pandas.io.sql as sqlio
from sklearn.metrics.pairwise import cosine_similarity

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
        print(request.form, file=sys.stderr)
        conn = get_db_connection()
        sql = "SELECT customer_id, product_id FROM likes;"
        data = sqlio.read_sql_query(sql, conn)
        conn.close()
        # cur = conn.cursor()
        # cur.execute('SELECT * FROM products ORDER BY RANDOM() LIMIT 5;')
        # products = cur.fetchall()
        # cur.close()
        # print(products, file=sys.stderr)  # Printing to console

        # Dataframe target_customer (customer_id) -> like (product_id)
        #df_targetCustomer_likedProductcs = pd.DataFrame(data)
        print(data, file=sys.stderr)

        return jsonify("test")
    else:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('SELECT * FROM products ORDER BY RANDOM() LIMIT 5;')
        products = cur.fetchall()
        cur.close()
        conn.close()
        # print(products, file=sys.stderr)  # Printing to console
        id_list = []
        # Extract only IDs from Products
        for product in products:
            id_list.append(product[0])
        return jsonify(id_list)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
