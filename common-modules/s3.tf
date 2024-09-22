resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.bucket_name}"

  tags = {
    Name        = "${var.bucket_name}"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_policy" "cloudfront_s3_access" {
  bucket = aws_s3_bucket.s3_bucket.id
  policy =<<EOF
  "{
        "Version": "2008-10-17",
        "Id": "PolicyForCloudFrontPrivateContent",
        "Statement": [
            {
                "Sid": "AllowCloudFrontServicePrincipal",
                "Effect": "Allow",
                "Principal": {
                    "Service": "cloudfront.amazonaws.com"
                },
                "Action": "s3:GetObject",
                "Resource": "${var.bucket_name}/*",
                "Condition": {
                    "StringEquals": {
                      "AWS:SourceArn": "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.s3_distribution.id}"
                    }
                }
            }
        ]
      }" 
    EOF
}

