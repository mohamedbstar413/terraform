resource "aws_iam_role" "back_ec2_role" {
  name =                "back_ec2_role"
  #allow ec2 to assume this role
  assume_role_policy = jsonencode(
    { 
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  }
  )
  /*managed_policy_arns = [
    aws_iam_policy.back_ec2_sm_policy.arn
    ,aws_iam_policy.back_ec2_sns_policy.arn
    ,aws_iam_policy.back_ec2_s3_policy.arn
    , aws_iam_policy.back_ec2_rds_policy.arn
    ]*/
}

resource "aws_iam_policy" "back_ec2_sm_policy" {
  name =                "back_ec2_secretsmanager_policy"
  
  policy = jsonencode({
    
        "Version": "2012-10-17",
        "Statement": [
        {
            "Sid": "Statement1",
            "Effect": "Allow",
            "Action": "secretsmanager:*",
            "Resource": "arn:aws:secretsmanager:us-east-1:910148268074:secret:book/rds/admin_password2-hB0xsu"
        }
    ]
    })
}

resource "aws_iam_policy" "back_ec2_sns_policy" {
  name =                  "back_ec2_sns_policy"

  policy = jsonencode(
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "Statement2",
                "Effect": "Allow",
                "Action": "sns:*",
                "Resource": "*"
            }
        ]
    }
  )
}

resource "aws_iam_policy" "back_ec2_s3_policy" {
  name =                  "back_ec2_s3_policy"

  policy = jsonencode(
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "Statement3",
                "Effect": "Allow",
                "Action": "s3:*",
                "Resource": "*"
            }
        ]
    }
  )
}

resource "aws_iam_policy" "back_ec2_rds_policy" {
  name =                  "back_ec2_rds_policy"

  policy = jsonencode(
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "Statement3",
                "Effect": "Allow",
                "Action": "rds:*",
                "Resource": "*"
            }
        ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "role_poicy_attachment_rds" {
  role =                 aws_iam_role.back_ec2_role.name
  policy_arn =            aws_iam_policy.back_ec2_rds_policy.arn
}
resource "aws_iam_role_policy_attachment" "role_poicy_attachment_s3" {
  role =                 aws_iam_role.back_ec2_role.name
  policy_arn =            aws_iam_policy.back_ec2_s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "role_poicy_attachment_sm" {
  role =                 aws_iam_role.back_ec2_role.name
  policy_arn =            aws_iam_policy.back_ec2_sm_policy.arn
}
resource "aws_iam_role_policy_attachment" "role_poicy_attachment_sns" {
  role =                 aws_iam_role.back_ec2_role.name
  policy_arn =            aws_iam_policy.back_ec2_sns_policy.arn
}

resource "aws_iam_instance_profile" "back_ec2_instance_profile" {
  name =                "back_ec2_instance_profile"
  role =                aws_iam_role.back_ec2_role.name
}
