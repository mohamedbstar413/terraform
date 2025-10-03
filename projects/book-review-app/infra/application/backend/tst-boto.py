import boto3
import json
def get_secret():
    client = boto3.client('secretsmanager', region_name= "us-east-1")
    secret_name = "book/rds/admin_password2"
    try:
        response = client.get_secret_value(SecretId=secret_name)
        if 'SecretString' in response:
            secret = response["SecretString"]
            secret_dict = json.loads(secret)  # if your secret is stored as JSON
            print("Secret:", secret_dict)
        else:
            binary_secret = response["SecretBinary"]
            print("Binary Secret:", binary_secret)
    except KeyError:
        print("Error")
get_secret()