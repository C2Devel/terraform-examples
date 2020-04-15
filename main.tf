variable "ec2_url" {
}

variable "s3_url" {
}

variable "access_key" {
}

variable "secret_key" {
}

variable "ami" {
}

variable "public_ipv4_pool" {
}

variable "region" {
  default = "croc"
}

variable "az" {
}

variable "instance_type" {
  default = "m1.micro"
}

variable "account_id" {
}

variable "template_owner" {
}

variable "template_name" {
}

variable "insecure" {
  default = false
}

provider "tls" {
}

provider "aws" {
  endpoints {
    # NOTE: specify custom EC2 endpoint URL
    #       due to different region name
    ec2 = var.ec2_url
  }

  # NOTE: STS API is not implemented, skip validation
  skip_credentials_validation = true

  # NOTE: IAM API is not implemented, skip validation
  skip_requesting_account_id = true

  # NOTE: Region has different name, skip validation
  skip_region_validation = true

  insecure   = var.insecure
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

provider "aws" {
  alias = "noregion"
  endpoints {
    # NOTE: specify custom EC2 endpoint URL
    #       due to different region name
    s3 = var.s3_url
  }

  # NOTE: STS API is not implemented, skip validation
  skip_credentials_validation = true

  # NOTE: IAM API is not implemented, skip validation
  skip_requesting_account_id = true

  # NOTE: Region has different name, skip validation
  skip_region_validation = true

  insecure   = var.insecure
  access_key = var.access_key
  secret_key = var.secret_key
  region     = "us-east-1"
}

