variable "acls" {
  default = ["private", "public-read","public-read-write", "authenticated-read"]
}

resource "aws_s3_bucket" "acl_example" {
  # NOTE: 'noncurrent_version_transition', 'replication', 'logging',
  #       'acceleration_status', 'region', 'request_payer',
  #       'replication_configuration', 'object_lock',
  #       'server_side_encryption_configuration' attributes are not supported.
  #       Supported values for 'acl' attribute are 'private',
  #       'public-read','public-read-write','authenticated-read'.
  count = 4
  provider = aws.noregion
  bucket_prefix = "acl_example"
  acl = var.acls[count.index]
  force_destroy = true
}

resource "aws_s3_bucket" "policy_example" {
  # NOTE: 'aws_s3_bucket_resource' with specific policy.
  #       More info about supported polices:
  #       http://docs.website.cloud.croc.ru/en/api/s3/features.html#bucket-policy
  provider = aws.noregion
  bucket   = "policy_example"
  acl      = "private"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:CreateBucket"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3::policy_example/*",
      "Principal": "*"
    }
  ]
}
POLICY
}

resource "aws_s3_bucket" "website_routing_rules_example" {
  # NOTE: 'aws_s3_bucket' with specific routing rules.
  provider = aws.noregion
  bucket = "website_routing_rules_example"
  acl = "public-read"
  website {
    index_document = "index.html"
    error_document = "error.html"
    routing_rules = <<RULES
[{
   "Condition": {
       "HttpErrorCodeReturnedEquals": "404"
   },
   "Redirect": {
       "HostName": "ya.ru",
       "HttpRedirectCode": "301",
       "Protocol": "https"
   }
}]
RULES
  }
}

resource "aws_s3_bucket" "cors_example" {
  # NOTE: 'aws_s3_bucket' with cors rule.
  provider = aws.noregion
  bucket = "cors_example"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["https://your.site"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket" "versioning_example" {
  # NOTE: 'aws_s3_bucket' with enabled versioning.
  bucket = "versioning_example"
  provider = aws.noregion

  versioning {
    enabled = true
    mfa_delete = false
  }
}

resource "aws_s3_bucket" "lifecycle_example" {
  # NOTE: 'aws_s3_bucket' with various lifecycle rules.
  #       More info about supported lifecycle rules:
  #       http://docs.website.cloud.croc.ru/en/api/s3/features.html#bucket-lifecycle
  provider = aws.noregion
  bucket = "lifecycle_example"

  lifecycle_rule {
    id      = "log"
    enabled = true

    prefix = "log/"

    expiration {
      days = 90
    }
  }

  lifecycle_rule {
    id      = "tmp"
    prefix  = "tmp/"
    enabled = true

    expiration {
      date = "2020-01-12"
    }
  }

  lifecycle_rule {
    id      = "trash"
    prefix  = "trash/"
    enabled = true

    expiration {
      expired_object_delete_marker = true
    }
  }
  lifecycle_rule {
    id      = "trash2"
    prefix  = "trash2/"
    enabled = true
    noncurrent_version_expiration {
      days = 30
    }
  }
}
