import os
import psycopg2
from flask import Flask, jsonify

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
def index():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT * FROM users;')
    users = cur.fetchall()
    cur.close()
    conn.close()
    return jsonify(users)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
