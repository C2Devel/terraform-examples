resource "aws_vpc" "vpc" {
  # Задаём IP-адрес сети VPC в нотации CIDR (IP/Prefix)
  cidr_block         = "172.16.8.0/24"
  # Активируем поддержку разрешения доменных имён с помощью DNS-серверов К2 Облака
  enable_dns_support = true

  # Присваиваем создаваемому ресурсу тег Name
  tags = {
    Name = "My project"
  }
}

resource "aws_subnet" "subnet" {
  # Задаём зону доступности, в которой будет создана подсеть
  # Её значение берём из переменной az
  availability_zone = var.az
  # Используем для подсети тот же CIDR-блок IP-адресов, что и для VPC
  cidr_block        = aws_vpc.vpc.cidr_block
  # Указываем VPC, где будет создана подсеть
  vpc_id            = aws_vpc.vpc.id

  # В тег Name для подсети включаем значение переменной az и тег Name для VPC
  tags = {
    Name = "Subnet in ${var.az} for ${lookup(aws_vpc.vpc.tags, "Name")}"
  }
}

resource "aws_internet_gateway" "igw" {
  # Указываем VPC, к которому будет присоединён интернет-шлюз
  vpc_id = aws_vpc.vpc.id

  # В тег Name для интернет-шлюза включаем тег Name для VPC
  tags = {
    Name = "IGW for ${lookup(aws_vpc.vpc.tags, "Name")}"
  }
}

resource "aws_route" "igw_route" {
  # Выбираем основную таблицу маршрутизации VPC
  route_table_id         = aws_vpc.vpc.main_route_table_id
  # Указываем IP-адрес сети назначения в нотации CIDR (IP/Prefix)
  destination_cidr_block = "0.0.0.0/0"
  # Указываем в качестве шлюза созданный интернет-шлюз
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_key_pair" "pubkey" {
  # Указываем имя SSH-ключа (значение берётся из переменной pubkey_name)
  key_name   = var.pubkey_name
  # и содержимое публичного ключа
  public_key = var.public_key
}

resource "aws_s3_bucket" "bucket" {
  # Задаём имя хранилища из переменной bucket_name
  bucket = var.bucket_name
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  # Указываем разрешения на доступ к созданному бакету
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}

resource "aws_eip" "eips" {
  # Указываем количество выделяемых EIP в переменной eips_count –
  # это позволяет сразу выделить необходимое количество EIP.
  # В нашем случае адрес выделяется только первому серверу
  count = var.eips_count

  # В качестве значения тега Name берём имя хоста будущей ВМ из переменной hostnames
  # по индексу из массива
  tags = {
    Name = "${var.hostnames[count.index]}"
  }
}

# Создаём группу безопасности для доступа извне
resource "aws_security_group" "ext" {
  # В рамках нашего VPC
  vpc_id = aws_vpc.vpc.id
  # задаём имя группы безопасности
  name = "ext"
  # и её описание
  description = "External SG"

  # Определяем входящие правила
  dynamic "ingress" {
    # Задаём имя переменной, которая будет использоваться
    # для перебора всех заданных портов
    iterator = port
    # Перебираем порты из списка портов allow_tcp_ports
    for_each = var.allow_tcp_ports
    content {
      # Задаём диапазон портов (в нашем случае он состоит из одного порта),
      from_port = port.value
      to_port   = port.value
      # протокол,
      protocol = "tcp"
      # и IP-адрес источника в нотации CIDR (IP/Prefix)
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Определяем исходящее правило — разрешаем весь исходящий IPv4-трафик
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "External SG"
  }
}

# Создаём внутреннюю группу безопасности,
# внутри которой будет разрешён весь трафик между её членами
resource "aws_security_group" "int" {
  vpc_id      = aws_vpc.vpc.id
  name        = "int"
  description = "Internal SG"

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Internal SG"
  }
}

resource "aws_instance" "vms" {
  # Количество создаваемых виртуальных машин берём из переменной vms_count
  count = var.vms_count
  # ID образа для создания экземпляра ВМ — из переменной vm_template
  ami = var.vm_template
  # Наименование типа экземпляра создаваемой ВМ — из переменной vm_instance_type
  instance_type = var.vm_instance_type
  # Назначаем экземпляру внутренний IP-адрес из созданной ранее подсети в VPC
  subnet_id = aws_subnet.subnet.id
  # Подключаем к создаваемому экземпляру внешнюю и внутреннюю группы безопасности
  vpc_security_group_ids = [
    aws_security_group.ext.id,
    aws_security_group.int.id,
  ]
  # Добавляем на сервер публичный SSH-ключ, созданный ранее
  key_name = aws_key_pair.pubkey.key_name

  tags = {
    Name = "VM for ${var.hostnames[count.index]}"
  }

  # Создаём диск, подключаемый к экземпляру
  ebs_block_device {
    # Говорим удалять диск вместе с экземпляром
    delete_on_termination = true
    # Задаём имя устройства вида "disk<N>",
    device_name = "disk1"
    # его тип
    volume_type = var.vm_volume_type
    # и размер
    volume_size = var.vm_volume_size

    tags = {
      Name = "Disk for ${var.hostnames[count.index]}"
    }
  }
}

resource "aws_eip_association" "eips_association" {
  # Получаем количество созданных EIP
  count         = var.eips_count
  # и по очереди назначаем каждый из них экземплярам
  instance_id   = element(aws_instance.vms.*.id, count.index)
  allocation_id = element(aws_eip.eips.*.id, count.index)
}
