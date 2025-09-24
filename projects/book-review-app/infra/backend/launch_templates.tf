resource "aws_launch_template" "book_backend_ec2_launch_template" {

    image_id =                      data.aws_ami.ubuntu_image
    instance_type =                 var.instance_type
    key_name =                      "new-key"

    vpc_security_group_ids =        [aws_security_group.back_ec2_sg.id]
    user_data =                     "[put user data file here]"

  tags = {
      Name =                        "Backend instance"
    }
}