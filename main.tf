terraform {
  required_providers {
    aws = {
      source  = "hc-registry.website.k2.cloud/c2devel/rockitcloud"
      version = "~> 25.5.5"
    }
    tls = {
      source  = "hc-registry.website.k2.cloud/hashicorp/tls"
      version = "~> 3.1.0"
    }
  }
}

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "ami" {
  type = string
}

variable "public_ipv4_pool" {
  type = string
}

variable "region" {
  type    = string
  default = "ru-msk"
}

variable "az" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "m1.micro"
}

variable "account_id" {
  type = string
}

variable "template_owner" {
  type = string
}

variable "template_name" {
  type = string
}

provider "tls" {
  type = string
}

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}
