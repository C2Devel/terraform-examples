variable "ec2_url" {}
variable "access_key" {}
variable "secret_key" {}

variable "region" {
  default = "croc"
}

variable "az" {}

variable "instance_type" {
  default = "m1.micro"
}

provider "aws" {
  endpoints {
    # NOTE: specify custom EC2 endpoint URL
    #       due to different region name
    ec2 = "${var.ec2_url}"
  }

  # NOTE: STS API is not implemented, skip validation
  skip_credentials_validation = true

  # NOTE: IAM API is not implemented, skip validation
  skip_requesting_account_id = true

  # NOTE: Region has different name, skip validation
  skip_region_validation = true

  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}
