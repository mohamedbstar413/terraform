from flask import Flask, request, jsonify
import mysql.connector, os
from flask_cors import CORS
import boto3
from botocore.exceptions import ClientError
import json

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}}, supports_credentials=False)

db_host="localhost"
db_user=""
db_password=""
db_name="new_db"

def get_secret():
    global db_user
    global db_password
    client = boto3.client('secretsmanager', region_name= "us-east-1")
    secret_name = "book/rds/admin_password2"
    try:
        response = client.get_secret_value(SecretId=secret_name)
        if 'SecretString' in response:
            secret = response["SecretString"]
            secret_dict = json.loads(secret)  # if your secret is stored as JSON
            print("Secret:", secret_dict)
            db_user = secret_dict['username']
            db_password = secret_dict['password']
        else:
            binary_secret = response["SecretBinary"]
            print("Binary Secret:", binary_secret)
    except ClientError:
        print("Error")

def send_email():
    sns = boto3.client('sns', region_name="us-east-1")
    topic_arn = os.environ.SNS_REVIEW_TOPIC_ARN
    print('topic arn: ', topic_arn)
    sns.publish(TopicArn=topic_arn,Message="A Review has been added")

get_secret()
db = mysql.connector.connect(
    host='localhost',
    user=db_user,
    password=db_password,
    database='new_db'
)

@app.route("/books")
def books():
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM books")
    #print("books are: ", cursor.fetchall())
    return jsonify(cursor.fetchall())

'''@app.route("/review", methods=["POST"])
def review():
    data = request.json
    print(data)
    cursor = db.cursor()
    cursor.execute("INSERT INTO reviews (book_id, review) VALUES (%s, %s)",
                   (data["book_id"], data["review"]))
    db.commit()
    return {"message": "Review added!"}, 201


'''
@app.route("/reviews", methods=["GET", "POST", "OPTIONS"])
def reviews():
    if request.method == "OPTIONS":
        # Preflight request
        return jsonify({}), 200

    if request.method == "GET":
        return jsonify({"msg": "all reviews"})

    if request.method == "POST":
        data = request.json
        print(data)
        cursor = db.cursor()
        cursor.execute("INSERT INTO reviews (book_id, review) VALUES (%s, %s)",
                   (data["book_id"], data["review"]))
        db.commit()
        send_email() #publish to sns topic to send an email than a review has been added
        return {"message": "Review added! Check the Queue"}, 201

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)