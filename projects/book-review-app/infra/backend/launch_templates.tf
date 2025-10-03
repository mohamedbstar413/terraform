resource "aws_launch_template" "book_backend_ec2_launch_template" {
    image_id =                      data.aws_ami.ubuntu_image.id
    instance_type =                 var.instance_type
    key_name =                      "new-key"

    vpc_security_group_ids =        [aws_security_group.back_ec2_sg.id]
    #provide the sns topic as an environment variable for any ec2 created via ASG
    user_data =  base64encode(<<-EOT
              #!/bin/bash
              echo "export REVIEW_SNS_TOPIC_ARN=${var.book_review_added_sns_topic_arn}" >> /etc/profile.d/custom_env.sh
              chmod +x /etc/profile.d/custom_env.sh
            EOT
    )

    iam_instance_profile {
      name =                        var.back_ec2_instance_profile_name
    }

  tags = {
      Name =                        "Backend instance"
    }
}