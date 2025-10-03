resource "aws_sns_topic" "book_review_added_sns_topic" {
  name =                "book_review_added_sns_topic"
}

resource "aws_sns_topic_policy" "book_review_added_sns_topic_policy" {
  arn =                 aws_sns_topic.book_review_added_sns_topic.arn
  #limit who can do operations on the sns topic
  policy =              data.aws_iam_policy_document.sns_book_review_topic_policy.json
}

data "aws_iam_policy_document" "sns_book_review_topic_policy" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        var.account-id,
      ]
    }

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.book_review_added_sns_topic.arn
    ]

    sid = "__default_statement_ID"
  }
}
resource "aws_sns_topic_subscription" "book_review_sns_email_subscription" {
  topic_arn =            aws_sns_topic.book_review_added_sns_topic.arn
  protocol =             "email"
  endpoint =             "mabdelsattar413@gmail.com"
}