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
    ec2 = "${var.ec2_url}"
  }

  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_region_validation      = true

  insecure   = true
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}
