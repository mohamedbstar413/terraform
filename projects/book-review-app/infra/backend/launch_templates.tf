resource "aws_launch_template" "book_backend_ec2_launch_template" {
    image_id =                      data.aws_ami.ubuntu_image.id
    instance_type =                 var.instance_type
    key_name =                      "new-key"

    depends_on = [ var.python_s3 ] #enforce creating the python code bucket and object first

    vpc_security_group_ids =        [aws_security_group.back_ec2_sg.id]
    #provide the sns topic as an environment variable for any ec2 created via ASG
    user_data =  base64encode(<<-EOT
              #!/bin/bash
              until apt-get update -y; do
                echo "apt-get update failed, retrying in 10 seconds..."
                sleep 5
              done
              echo "export REVIEW_SNS_TOPIC_ARN=${var.book_review_added_sns_topic_arn}" >> /etc/profile.d/custom_env.sh
              chmod +x /etc/profile.d/custom_env.sh

              sudo apt update -y
              sudo apt install -y python3
              sudo apt install -y python3-pip

              sudo apt install unzip

              pip3 install boto3

              
              pip3 install flask
              pip3 install flask-cors
              pip3 install mysql-connector-python

              pip3 install boto3 botocore

              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              sudo ./aws/install

              # Download your code from S3
              aws s3 cp s3://book-review-python-app-s3-storage-bucket/app.py /home/ubuntu/app.py

              # Run the server in background
              python3 /home/ubuntu/app.py
            EOT
    )

    iam_instance_profile {
      name =                        var.back_ec2_instance_profile_name
    }

  tags = {
      Name =                        "Backend instance"
    }
}