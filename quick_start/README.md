# Использование Terraform вместе с К2 Облаком

## Общая информация

Terraform – современный инструмент для автоматизированного управления облачной инфраструктурой при помощи простого выразительного языка, похожего на обычный английский.
Код на этом языке пишется в декларативной манере: вы описываете, что хотите получить в результате — вам не надо задумываться, каким образом его достичь.

Однажды написав такой код, вы можете переиспользовать его многократно — для этого достаточно лишь набрать пару коротких команд в терминале.
И каждый раз вы получите предсказуемый результат — в облаке будет создано требуемое количество виртуальных машин из указанных шаблонов, выделено необходимое количество внешних IP-адресов, сконфигурированы группы безопасности и выполнены все описанные в коде действия.
Выполнение этих же действий в веб-интерфейсе займёт больше времени, особенно если вам необходимо их повторять.
К тому же, при ручных манипуляциях многократно возрастает риск допустить ошибку и получить не совсем то, что хотелось, а затем долго искать, где и в какой момент была сделана ошибка.

Такой подход к развёртыванию инфраструктуры получил название «инфраструктура как код» (Infrastructure as a Code, IaaC).
Он позволяет:

- использовать системы управления версиями;
- размещать комментарии в коде, чтобы документировать производимые им действия;
- тестировать код до его применения в реальной инфраструктуре для выявления возможных негативных последствий;
- передавать код другим разработчикам для оценки его качества, чтобы в итоге получить лучшее решение.

## Установка и настройка

> :information_source: &nbsp; Инструкция написана и протестирована с использованием Terraform v1.0.8 для провайдеров rockitcloud v24.1.0 и AWS v3.63.0. Приведённая ниже информация актуальна для указанных версий. Чтобы гарантировать стабильность и совместимость, мы зафиксировали версию провайдера в коде конфигурации.

Terraform распространяется в виде исполняемого файла и доступен для различных ОС (Linux/Windows/macOS и не только). Скачать нужную версию можно [на официальной странице загрузки](https://www.terraform.io/downloads.html). Если официальная страница будет недоступна, скачайте дистрибутив [здесь](https://hc-releases.website.k2.cloud/terraform/current/). После загрузки и распаковки архива рекомендуем перенести извлечённый файл в любую папку, заданную в текущей переменной окружения `PATH`(или добавить целевую папку в эту переменную).
Для ОС семейства Linux это может быть `/usr/local/bin/`, для Windows – `C:\Windows\system32` (для доступа к системным папкам требуются права администратора в ОС). Таким образом, вам не придётся каждый раз указывать полный путь к файлу.

## Написание конфигурации Terraform

Готовый код, который описан далее, размещён в нашем официальном репозитории [terraform-examples](https://github.com/c2devel/terraform-examples>) на GitHub в папке `quick_start`. Вы можете скачать его и сразу начать использовать с минимальными правками. Однако для лучшего понимания кода рекомендуем последовательно выполнить все шаги и все операции этого руководства.

> :warning: &nbsp; При работе с Terraform команды следует выполнять, только если вы хорошо представляете, что и для чего делаете. Terraform предупреждает о потенциально деструктивных операциях и требует дополнительного подтверждения в этих случаях. Внимательно относитесь к этим предупреждениям, потому что иначе вы можете нечаянно лишиться части или даже всей инфраструктуры вашего проекта вместе с данными. А если резервных копий нет, то данные окажутся безвозвратно потеряны.

В качестве примера рассмотрим описание конфигурации Terraform для автоматического создания инфраструктуры в составе:

- 1 VPC (для изоляции инфраструктуры проекта на сетевом уровне);
- 1 подсеть с префиксом 24;
- 2 виртуальные машины – в проекте-примере на одной из них будет размещено веб-приложение, а на другой сервер баз данных;
- 1 Elastic IP – адрес будет назначен виртуальной машине с веб-приложением, чтобы к ней (и приложению) был возможен доступ из интернет;
- 2 группы безопасности – одна группа разрешает входящий трафик от интерфейсов, которым она назначена, чтобы ВМ взаимодействовали только между собой внутри созданной подсети. Другая открывает доступ извне через TCP-порты 22, 80 и 443. Для каждой из групп разрешён весь исходящий трафик;
- 1 бакет для хранения файлов проекта.

### Описание провайдеров – providers.tf

Terraform работает с разными облачными платформами и сервисами при помощи специальных плагинов, которые принято называть провайдерами.
Для работы с К2 Облаком можно использовать провайдер от C2Devel (*c2devel/rockitcloud*) или провайдер AWS (*hashicorp/aws*), так как API облака совместимо с AWS.

Создадим файл `providers.tf`, в котором опишем необходимых провайдеров и их настройки:

```bash
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
  region     = "ru-msk"
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
```

Первый блок `provider` относится к работе со всеми сервисами К2 Облака за исключением объектного хранилища – за работу с ним отвечает второй блок.
Если планируется работа только с К2 Облаком, эту часть кода можно переиспользовать без изменений.

Отметим, что `access_key` и `secret_key` не содержат самих данных, а указывают на значения переменных.
Это сделано специально, чтобы готовую конфигурацию можно было передавать другим людям, не опасаясь раскрыть значения ключей.
Кроме того, такой подход позволяет быстро задать все ключи в одном месте и избежать множества правок в самом коде при их изменении.

### Описание переменных – variables.tf

Информация обо всех используемых переменных хранится в файле `variables.tf`, где для каждой переменной можно указать её описание и значение по умолчанию.

```bash
variable "secret_key" {
  description = "Enter the secret key"
}

variable "access_key" {
  description = "Enter the access key"
}

variable "public_key" {
  description = "Enter the public SSH key"
}

variable "pubkey_name" {
  description = "Enter the name of the public SSH key"
}

variable "bucket_name" {
  description = "Enter the bucket name"
}

variable "az" {
  description = "Enter availability zone (ru-msk-comp1p by default)"
  default     = "ru-msk-comp1p"
}

variable "eips_count" {
  description = "Enter the number of Elastic IP addresses to create (1 by default)"
  default     = 1
}

variable "vms_count" {
  description = "Enter the number of virtual machines to create (2 by default)"
  default     = 2
}

variable "hostnames" {
  description = "Enter hostnames of VMs"
}

variable "allow_tcp_ports" {
  description = "Enter TCP ports to allow connections to (22, 80, 443 by default)"
  default     = [22, 80, 443]
}

variable "vm_template" {
  description = "Enter the template ID to create a VM from (cmi-AC76609F [CentOS 8.2] by default)"
  default     = "cmi-AC76609F"
}

variable "vm_instance_type" {
  description = "Enter the instance type for a VM (m5.2small by default)"
  default     = "m5.2small"
}

variable "vm_volume_type" {
  description = "Enter the volume type for VM disks (gp2 by default)"
  default     = "gp2"
}

variable "vm_volume_size" {
  # Размер по умолчанию и шаг наращивания указаны для типа дисков gp2
  # Для других типов дисков они могут быть иными – подробнее см. в документации на диски
  description = "Enter the volume size for VM disks (32 by default, in GiB, must be multiple of 32)"
  default     = 32
}
```

В файле `variables.tf` содержится только список всех переменных для конфигурации (и значения по умолчанию для некоторых из них). Сами значения, используемые в работе, задаются в файле `terraform.tfvars`.

### Используемые значения переменных – terraform.tfvars

Те значения, которые будут применяться в каждом конкретном случае, указываются в файле `terraform.tfvars`.
Его содержимое имеет приоритет над значениями по умолчанию, это позволяет легко переопределить стандартное поведение конфигурации.

```bash
secret_key       = "ENTER_YOUR_SECRET_KEY_HERE"
access_key       = "ENTER_YOUR_ACCESS_KEY_HERE"
public_key       = "ENTER_YOUR_PUBLIC_KEY_HERE"
pubkey_name      = "My-project-SSH-key"
bucket_name      = "My-project-bucket"
az               = "ru-msk-comp1p"
eips_count       = 1
vms_count        = 2
hostnames        = ["webapp", "db"]
allow_tcp_ports  = [22, 80, 443]
vm_template      = "cmi-AC76609F"
vm_instance_type = "m5.2small"
vm_volume_type   = "gp2"
vm_volume_size   = 32
```

Шаблон со всеми переменными и их значениями находится в файле `terraform.tfvars.example`.
Чтобы ускорить задание переменных, его содержимое можно скопировать в файл `terraform.tfvars`, а затем поменять значения на необходимые:

```bash
cp terraform.tfvars.example terraform.tfvars
```

> :warning: &nbsp; Помните, что в файле `terraform.tfvars` могут хранится чувствительные данные, которые не должны попасть к посторонним, например, значения ваших ключей. Если вы используете систему Git для хранения и версионирования конфигураций Terraform, убедитесь, что файл не попадёт в репозиторий в результате коммита – этого можно избежать, включив соответствующее исключение в `.gitignore`. Кроме того, если вы передаёте другими людям свою конфигурацию Terraform, убедитесь, что при этом не передаёте `terraform.tfvars`. Утечка ключей может привести к тому, что посторонние лица получат доступ к управлению вашей инфраструктурой.

Получить свои значения `secret_key` и `access_key` можно [в консоли управления Облаком](https://console.k2.cloud). Для этого нажмите на логин пользователя в правом верхнем углу, выберите "Профиль" и нажмите "Получить настройки доступа к API".

В К2 Облаке поддерживаются 2084-разрядные ключи RSA. SSH-ключ можно сгенерировать, например, при помощи команды:

```bash
ssh-keygen -b 2048 -t rsa
```

В качестве значения `public_key` укажите его публичную часть.

Имя ключа `pubkey_name` может содержать только латинские буквы и цифры.
Имя бакета `bucket_name` может дополнительно содержать [точки, дефисы и подчеркивания](https://docs.k2.cloud/ru/services/object_storage/operations.html#s3bucketnaming).

Когда все переменные описаны и их значения заданы, можно приступать к написанию основной конфигурации.

### Основная конфигурация – main.tf

В файле основной конфигурации `main.tf` пишется код, в соответствии с которым в дальнейшем будут выполняться все основные действия над инфраструктурой в автоматическом режиме.

Конфигурация состоит из блоков кода, каждый из которых, как правило, отвечает за работу с объектом определённого типа, например, за работу с виртуальными машинами или группами безопасности.
Такие блоки в терминологии Terraform называются ресурсами.
Далее по очереди рассматриваются все блоки ресурсов, которые необходимы для описания указанной выше конфигурации.
В каждом блоке есть комментарии с пояснениями производимых изменений.

Сначала создадим VPC для изоляции ресурсов проекта на сетевом уровне:

```bash
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
```

Затем определим подсеть в ранее созданном VPC (CIDR-блок подсети должен принадлежать адресному пространству, выделенному VPC):

```bash
resource "aws_subnet" "subnet" {
  # Задаём зону доступности, в которой будет создана подсеть
  # Её значение берём из переменной az
  availability_zone = var.az
  # Используем для подсети тот же CIDR-блок IP-адресов, что и для VPC
  cidr_block        = aws_vpc.vpc.cidr_block
  # Указываем VPC, где будет создана подсеть
  vpc_id            = aws_vpc.vpc.id
  # Подсеть создаём только после создания VPC
  depends_on        = [aws_vpc.vpc]

  # В тег Name для подсети включаем значение переменной az и тег Name для VPC
  tags = {
    Name = "Subnet in ${var.az} for ${lookup(aws_vpc.vpc.tags, "Name")}"
  }
}
```

Далее добавляем публичный SSH-ключ, который позже будет использоваться для доступа к виртуальной машине:

```bash
resource "aws_key_pair" "pubkey" {
  # Указываем имя SSH-ключа (значение берётся из переменной pubkey_name)
  key_name   = var.pubkey_name
  # и содержимое публичного ключа
  public_key = var.public_key
}
```

Создаём бакет в объектном хранилище для хранения данных сайта и резервных копий:

```bash
resource "aws_s3_bucket" "bucket" {
  provider = aws.noregion
  # Задаём имя хранилища из переменной bucket_name
  bucket = var.bucket_name
  # Указываем разрешения на доступ
  acl    = "private"
}
```

Выделяем Elastic IP для доступа к серверу с веб-приложением извне:

```bash
resource "aws_eip" "eips" {
  # Указываем количество выделяемых EIP в переменной eips_count –
  # это позволяет сразу выделить необходимое количество EIP.
  # В нашем случае адрес выделяется только первому серверу
  count = var.eips_count
  # Выделяем в рамках нашего VPC
  vpc = true
  # и только после его создания
  depends_on = [aws_vpc.vpc]

  # В качестве значения тега Name берём имя хоста будущей ВМ из переменной hostnames
  # по индексу из массива
  tags = {
    Name = "${var.hostnames[count.index]}"
  }
}
```

Затем создаём две группы безопасности – одна открывает доступ со всех адресов через порты 22, 80 и 443, а вторая разрешает полный доступ внутри себя самой.
В первую позже добавим ВМ с веб-приложением, а во вторую поместим оба наших сервера, чтобы они могли взаимодействовать между собой:

```bash
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

  # Определяем исходящее правило – разрешаем весь исходящий IPv4-трафик
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [aws_vpc.vpc]

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

  depends_on = [aws_vpc.vpc]

  tags = {
    Name = "Internal SG"
  }
}
```

Теперь напишем блок кода для создания виртуальных машин:

```bash
resource "aws_instance" "vms" {
  # Количество создаваемых виртуальных машин берём из переменной vms_count
  count = var.vms_count
  # ID шаблона для создания экземпляра ВМ – из переменной vm_template
  ami = var.vm_template
  # Наименование типа экземпляра создаваемой ВМ – из переменной vm_instance_type
  instance_type = var.vm_instance_type
  # Назначаем экземпляру внутренний IP-адрес из созданной ранее подсети в VPC
  subnet_id = aws_subnet.subnet.id
  # Подключаем к создаваемому экзепляру внутреннюю группу безопасности
  vpc_security_group_ids = [aws_security_group.int.id]
  # Добавляем на сервер публичный SSH-ключ, созданный ранее
  key_name = var.pubkey_name
  # Не выделяем и не присваиваем экземпляру внешний Elastic IP
  associate_public_ip_address = false
  # Активируем мониторинг экземпляра
  monitoring = true

  # Экземпляр создаём только после того как созданы:
  # – подсеть
  # – внутренняя группа безопасности
  # – публичный SSH-ключ
  depends_on = [
    aws_subnet.subnet,
    aws_security_group.int,
    aws_key_pair.pubkey,
  ]

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
```

После создания экземпляров виртуальных машин подключаем к первому внешнюю группу безопасности:

```bash
resource "aws_network_interface_sg_attachment" "sg_attachment" {
  # Получаем ID внешней группы безопасности
  security_group_id    = aws_security_group.ext.id
  # и ID сетевого интерфейса первого экземпляра
  network_interface_id = aws_instance.vms[0].primary_network_interface_id
  # Назначаем группу безопасности только после того, как созданы
  # соответствующие экземпляр и группа безопасности
  depends_on = [
    aws_instance.vms,
    aws_security_group.ext,
  ]
}
```

И внешний Elastic IP:

```bash
resource "aws_eip_association" "eips_association" {
  # Получаем количество созданных EIP
  count         = var.eips_count
  # и по очереди назначаем каждый из них экземплярам
  instance_id   = element(aws_instance.vms.*.id, count.index)
  allocation_id = element(aws_eip.eips.*.id, count.index)
}
```

### Выходные переменные – outputs.tf

При помощи подряд идущих блоков `output` в файле `outputs.tf` описываются все переменные, результат которых становится известен после применения плана конфигурации.

В нашем случае конфигурацию завершаем единственным блоком `output`.
Этот блок выводит в терминале Elastic IP-адрес сервера с веб-приложением, так что пользователю не надо искать его в веб-интерфейсе облака:

```bash
output "ip_of_webapp" {
  description = "IP of webapp"
  # Берём значение публичного IP-адреса первого экземпляра
  # и выводим его по завершении работы Terraform
  value       = aws_eip.eips[0].public_ip
}
```

Таким образом, мы можем сразу скопировать IP-адрес для подключения к серверу и продолжить работу с ним.

## Использование готовой конфигурации

В результате описанных действий получается конфигурация Terraform, состоящая из пяти файлов:

- **providers.tf** – файл с настройками подключения и взаимодействия с сервисами или платформами, на базе которых будет строиться инфраструктура;
- **variables.tf** – файл с описанием всех используемых переменных и их значениями по умолчанию;
- **terraform.tfvars** – файл со значениями переменных, включая секретные ключи и ключи доступа, поэтому его следует надёжно хранить в скрытом от посторонних месте;
- **main.tf** – основной файл конфигурации, в котором описана вся инфраструктура проекта, управляемая при помощи Terraform;
- **outputs.tf** – файл с описанием выходных переменных.

Чтобы развернуть с её помощью инфраструктуру, выполните пошагово следующие действия:

1. Клонируйте репозиторий и перейдите в папку, где находятся файлы конфигурации:

```bash
git clone https://github.com/C2Devel/terraform-examples.git && cd terraform-examples/quick_start
```

2. Скопируйте шаблон переменных окружения с их значениями из файла-примера:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Не забудьте внести в новый файл необходимые изменения. Для получения минимально рабочей конфигурации необходимо обязательно указать в нём свои `secret_key` и `access_key` для работы c API К2 Облака.

3. Выполните команду инициализации:

```bash
terraform init
```

С её помощью Terraform инициализирует конфигурацию, загрузит все необходимые плагины и будет готов к работе с инфраструктурой.

4. Выполните команду генерирования плана вносимых изменений:

```bash
terraform plan
```

В терминале будут отображены все изменения, которые Terraform планирует осуществить на реальной инфраструктуре.

5. Тщательно изучите вывод. Если предлагаемые изменения совпадают с ожидаемыми, примените их:

```bash
terraform apply
```

План будет выведен снова, внимательно проверьте его ещё раз. Для выполнения плана наберите `yes` и нажмите `Enter`.

Через некоторое время в К2 Облаке будет создана вся описанная инфраструктура. В дальнейшем, если потребуется внести в неё изменения, необходимо сделать правки в текущей конфигурации Terraform и повторно примененить план.

Чтобы ещё раз вывести в терминал значения выходных переменных, введите команду:

```bash
terraform output
```

Если потребуется удалить созданную при помощи Terraform инфраструктуру, это можно сделать следующей командой:

```bash
terraform destroy
```

В терминале будет отображён план удаления инфраструктуры, а для подтверждения удаления необходимо ввести `yes` и нажать `Enter`.

> :exclamation: &nbsp; Будьте особенно внимательны при выполнении данной команды – удаляется вся инфраструктура, описанная в конфигурации.

Подводя итог, основная конфигурация Terraform, которая непосредственно отвечает за действия над инфраструктурой, состоит из блоков – ресурсов.
Меняя последовательность и тип блоков, можно, как из элементов конструктора, создать именно ту инфраструктуру, которая требуется вашему проекту.

C дополнительными примерами использования Terraform, а также поддерживаемыми и неподдерживаемыми параметрами для каждого ресурса вы можете ознакомиться в нашем официальном репозитории [terraform-examples](https://github.com/c2devel/terraform-examples) на GitHub в папке ``cases``. Примеры составлены для провайдера AWS v3.63.0 (Terraform v0.14.0).
