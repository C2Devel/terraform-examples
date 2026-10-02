# Фиксируем версию провайдера, чтобы гарантировать совместимость
# и стабильную работу написанной конфигурации
terraform {
  required_providers {
    aws = {
      # Используем локальное зеркало К2 Облака
      # как источник загрузки провайдера c2devel/rockitcloud
      source  = "hc-registry.website.k2.cloud/c2devel/rockitcloud"
      version = "~> 25.5.5"
    }
  }
}

# Подключаем и настраиваем провайдера для работы
# со всеми сервисами К2 Облака
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key

  # Указываем регион К2 Облака
  region = "ru-msk"
}
