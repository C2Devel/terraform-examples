# Завершаем конфигурацию единственным блоком output, который
# выводит в терминале Elastic IP-адрес сервера с веб-приложением
output "ip_of_webapp" {
  description = "IP of webapp"
  # Берём значение публичного IP-адреса первого экземпляра
  # и выводим его по завершении работы Terraform
  value = aws_eip.eips[0].public_ip
}
