data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda/handler.py"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_iam_role" "lambda" {
  name = "ccaas-demo-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "connect_demo" {
  function_name    = "ccaas-demo-connect-lambda"
  role             = aws_iam_role.lambda.arn
  runtime          = "python3.12"
  handler          = "handler.lambda_handler"
  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256
}

resource "aws_connect_instance" "demo" {
  identity_management_type  = "CONNECT_MANAGED"
  inbound_calls_enabled     = true
  outbound_calls_enabled    = true
  contact_flow_logs_enabled = true
  instance_alias            = "ccaas-demo-connect"
}

resource "aws_kinesis_firehose_delivery_stream" "demo" {
  name        = "ccaas-demo-connect-events"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose.arn
    bucket_arn = aws_s3_bucket.demo.arn
  }
}

resource "aws_s3_bucket" "demo" {
  bucket = "ccaas-demo-connect-events-${data.aws_caller_identity.current.account_id}"
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "firehose" {
  name = "ccaas-demo-firehose-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "firehose.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "firehose" {
  role = aws_iam_role.firehose.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:AbortMultipartUpload", "s3:GetBucketLocation", "s3:ListBucket", "s3:PutObject"]
      Resource = [aws_s3_bucket.demo.arn, "${aws_s3_bucket.demo.arn}/*"]
    }]
  })
}

resource "aws_connect_hours_of_operation" "demo" {
  instance_id = aws_connect_instance.demo.id
  name        = "Demo hours"
  time_zone   = "America/New_York"

  config {
    day = "MONDAY"
    start_time {
      hours   = 9
      minutes = 0
    }
    end_time {
      hours   = 17
      minutes = 0
    }
  }
  config {
    day = "TUESDAY"
    start_time {
      hours   = 9
      minutes = 0
    }
    end_time {
      hours   = 17
      minutes = 0
    }
  }
  config {
    day = "WEDNESDAY"
    start_time {
      hours   = 9
      minutes = 0
    }
    end_time {
      hours   = 17
      minutes = 0
    }
  }
  config {
    day = "THURSDAY"
    start_time {
      hours   = 9
      minutes = 0
    }
    end_time {
      hours   = 17
      minutes = 0
    }
  }
  config {
    day = "FRIDAY"
    start_time {
      hours   = 9
      minutes = 0
    }
    end_time {
      hours   = 17
      minutes = 0
    }
  }
}

resource "aws_connect_queue" "demo" {
  instance_id           = aws_connect_instance.demo.id
  name                  = "Demo queue"
  description           = "Queue for the CCaaS demo"
  hours_of_operation_id = aws_connect_hours_of_operation.demo.hours_of_operation_id
}

resource "aws_lambda_permission" "connect" {
  statement_id  = "AllowAmazonConnect"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.connect_demo.function_name
  principal     = "connect.amazonaws.com"
  source_arn    = aws_connect_instance.demo.arn
}

resource "aws_connect_lambda_function_association" "demo" {
  instance_id  = aws_connect_instance.demo.id
  function_arn = aws_lambda_function.connect_demo.arn
}

resource "aws_connect_routing_profile" "demo" {
  instance_id               = aws_connect_instance.demo.id
  name                      = "Demo routing profile"
  description               = "Routing profile for the CCaaS demo"
  default_outbound_queue_id = aws_connect_queue.demo.queue_id
  media_concurrencies {
    channel     = "VOICE"
    concurrency = 1
  }
  queue_configs {
    channel  = "VOICE"
    delay    = 0
    priority = 1
    queue_id = aws_connect_queue.demo.queue_id
  }
}

resource "aws_connect_contact_flow" "demo" {
  instance_id = aws_connect_instance.demo.id
  name        = "Demo inbound flow"
  type        = "CONTACT_FLOW"
  content = templatefile("${path.module}/contact-flow.json.tftpl", {
    instance_arn = aws_connect_instance.demo.arn
    queue_arn    = aws_connect_queue.demo.arn
    lambda_arn   = aws_lambda_function.connect_demo.arn
  })
}