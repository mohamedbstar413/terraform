from flask import Flask, request, jsonify
import mysql.connector, os
from flask_cors import CORS
import boto3
from botocore.exceptions import ClientError
import json

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}}, supports_credentials=False)

db_host = ""
db_user = ""
db_password = ""
db_name = "bookDb"


def get_secret():
    global db_user
    global db_password
    client = boto3.client('secretsmanager', region_name="us-east-1")
    secret_name = "book/rds/admin_password2"
    try:
        response = client.get_secret_value(SecretId=secret_name)
        if 'SecretString' in response:
            secret = response["SecretString"]
            secret_dict = json.loads(secret)
            print("Secret:", secret_dict)
            db_user = secret_dict['username']
            db_password = secret_dict['password']
        else:
            binary_secret = response["SecretBinary"]
            print("Binary Secret:", binary_secret)
    except ClientError as e:
        print("Error getting secret:", e)


def get_rds_endpoint():
    global db_host
    rds = boto3.client("rds", region_name="us-east-1")
    db_identifier = "book-rds-db"
    response = rds.describe_db_instances(DBInstanceIdentifier=db_identifier)
    db_instance = response["DBInstances"][0]
    db_host = db_instance["Endpoint"]["Address"]
    port = db_instance["Endpoint"]["Port"]
    print(f"RDS Endpoint: {db_host}:{port}")


def notify_sns():
    sns = boto3.client('sns', region_name="us-east-1")
    topic_arn = os.environ.get("SNS_REVIEW_TOPIC_ARN")
    if topic_arn:
        print('topic arn: ', topic_arn)
        sns.publish(TopicArn=topic_arn, Message="A Review has been added")
    else:
        print("SNS topic ARN not set")


def init_db():
    global db_host, db_name, db_password, db_user
    try:
        conn = mysql.connector.connect(
            host=db_host,
            user=db_user,
            password=db_password
        )
        cursor = conn.cursor()

        # Create database if not exists
        cursor.execute(f"CREATE DATABASE IF NOT EXISTS {db_name}")
        conn.database = db_name

        # Create books table
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS books (
                id INT AUTO_INCREMENT PRIMARY KEY,
                title VARCHAR(255) NOT NULL
            )
        """)

        # Create reviews table
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS reviews (
                id INT AUTO_INCREMENT PRIMARY KEY,
                book_id INT NOT NULL,
                review TEXT NOT NULL,
                FOREIGN KEY (book_id) REFERENCES books(id)
            )
        """)

        # Insert sample book if table is empty
        cursor.execute("SELECT COUNT(*) FROM books")
        if cursor.fetchone()[0] == 0:
            cursor.execute("INSERT INTO books (title) VALUES (%s)", ("Devops Cookbook",))

        conn.commit()
        cursor.close()
        conn.close()
        print("Database and tables initialized successfully")

    except Exception as e:
        print("Error initializing database:", e)


# Initialization
get_secret()
get_rds_endpoint()
init_db()

db = mysql.connector.connect(
    host=db_host,
    user=db_user,
    password=db_password,
    database=db_name
)


@app.route("/books")
def books():
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM books")
    return jsonify(cursor.fetchall())


@app.route("/reviews", methods=["GET", "POST", "OPTIONS"])
def reviews():
    if request.method == "OPTIONS":
        return jsonify({}), 200

    if request.method == "GET":
        cursor = db.cursor(dictionary=True)
        cursor.execute("SELECT * FROM reviews")
        return jsonify(cursor.fetchall())

    if request.method == "POST":
        data = request.json
        cursor = db.cursor()
        cursor.execute(
            "INSERT INTO reviews (book_id, review) VALUES (%s, %s)",
            (data["book_id"], data["review"])
        )
        db.commit()
        notify_sns()
        return {"message": "Review added! Check the Queue"}, 201


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
