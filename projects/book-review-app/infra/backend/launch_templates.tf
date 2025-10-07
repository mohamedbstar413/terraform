resource "aws_launch_template" "book_backend_ec2_launch_template" {
    image_id =                      data.aws_ami.ubuntu_image.id
    instance_type =                 var.instance_type
    key_name =                      "new-key"

    depends_on = [ var.python_s3 ] #enforce creating the python code bucket and object first

    vpc_security_group_ids =        [aws_security_group.back_ec2_sg.id]
    #provide the sns topic as an environment variable for any ec2 created via ASG
    user_data =  base64encode(<<-EOT
              #!/bin/bash
              echo "export REVIEW_SNS_TOPIC_ARN=${var.book_review_added_sns_topic_arn}" >> /etc/profile.d/custom_env.sh
              chmod +x /etc/profile.d/custom_env.sh

              apt update -y
              pip3 install boto3

              apt install -y python3 awscli
              pip3 install flask
              pip3 install flask-cors
              pip3 install mysql-connector-python

              # Download your code from S3
              aws s3 cp s3://book_review_python_app_s3_storage_bucket/app.py /home/ubuntu/app.py

              # Run the server in background
              nohup python3 /home/ec2-user/server.py > /home/ec2-user/server.log 2>&1 &
            EOT
    )

    iam_instance_profile {
      name =                        var.back_ec2_instance_profile_name
    }

  tags = {
      Name =                        "Backend instance"
    }
}