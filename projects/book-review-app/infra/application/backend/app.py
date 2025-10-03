from flask import Flask, request, jsonify
import mysql.connector, os
from flask_cors import CORS
import boto3
from botocore.exceptions import ClientError
import json

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}}, supports_credentials=False)

db_host=""
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

def get_rds_endpoint():
    global db_host
    rds = boto3.client("rds", region_name="us-east-1")  # change region if needed
    db_identifier = "book_rds_db"
    response = rds.describe_db_instances(DBInstanceIdentifier=db_identifier)

    # Extract the endpoint info
    db_instance = response["DBInstances"][0]
    db_host = db_instance["Endpoint"]["Address"]
    port = db_instance["Endpoint"]["Port"]

    print(f"RDS Endpoint: {db_host}:{port}")

def notify_sns():
    sns = boto3.client('sns', region_name="us-east-1")
    topic_arn = os.environ.SNS_REVIEW_TOPIC_ARN
    print('topic arn: ', topic_arn)
    sns.publish(TopicArn=topic_arn,Message="A Review has been added")

get_secret() #get username and password for rds db
get_rds_endpoint() #get the rds db endpoint
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
        notify_sns() #publish to sns topic to send an email that a review has been added
        return {"message": "Review added! Check the Queue"}, 201

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)