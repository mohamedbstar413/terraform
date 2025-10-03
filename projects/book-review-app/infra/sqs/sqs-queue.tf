resource "aws_sqs_queue" "book_sqs_review_queue" {
  name = "book_sqs_review_queue"

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.book_sqs_deadletter_queue.arn
    maxReceiveCount     = 4
  })
}
#allow only sns queue to put messags into this queue
resource "aws_sqs_queue_policy" "book_sqs_review_queue_policy" {
  queue_url = aws_sqs_queue.book_sqs_review_queue.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "Allow-SNS-Publish"
        Effect = "Allow"
        Principal = "*"
        Action = "sqs:SendMessage"
        Resource = aws_sqs_queue.book_sqs_review_queue.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = var.book_sns_review_topic_arn
          }
        }
      }
    ]
  })
}

#provision a deadletter queue
resource "aws_sqs_queue" "book_sqs_deadletter_queue" {
  name = "book_sqs_deadletter_queue"
}
#allow only book_review_sqs_queue to put messages into this deadletter queue
resource "aws_sqs_queue_redrive_allow_policy" "terraform_queue_redrive_allow_policy" {
  queue_url = aws_sqs_queue.book_sqs_deadletter_queue.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.book_sqs_review_queue.arn]
  })
}

# Subscription: link SNS to SQS
resource "aws_sns_topic_subscription" "book_sns_to_sqs" {
  topic_arn = var.book_sns_review_topic_arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.book_sqs_review_queue.arn
}
