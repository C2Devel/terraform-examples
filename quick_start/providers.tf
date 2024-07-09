# Фиксируем версию провайдера, чтобы гарантировать совместимость
# и стабильную работу написанной конфигурации
terraform {
  required_providers {
    aws = {
      # Используем локальное зеркало К2 Облака
      # как источник загрузки провайдера c2devel/rockitcloud
      source  = "hc-registry.website.k2.cloud/c2devel/rockitcloud"
      version = "24.1.0"
    }
  }
}

# Подключаем и настраиваем провайдера для работы
# со всеми сервисами К2 Облака, кроме объектного хранилища
provider "aws" {
  endpoints {
    ec2 = "https://ec2.k2.cloud"
  }

  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_region_validation      = true

  insecure   = false
  access_key = var.access_key
  secret_key = var.secret_key
  region     = "region-1"
}

# Подключаем и настраиваем провайдера
# для работы с объектным хранилищем облака
provider "aws" {
  alias = "noregion"
  endpoints {
    s3 = "https://s3.k2.cloud"
  }

  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_region_validation      = true

  insecure   = false
  access_key = var.access_key
  secret_key = var.secret_key
  region     = "us-east-1"
}
