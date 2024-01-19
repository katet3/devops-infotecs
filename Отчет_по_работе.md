# Тестовое задание для стажера на позицию «DevOps»



Реализовать автоматизированную сборку библиотеки под Linux/Windows с использованием CMake на примере SQLite.

## 1. Написать CMakeLists.txt для компиляции исходников под: 



- **Windows (x86/x86_64)  – только dll при помощи MSVC** 		

  ```cmake
  if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
      # Для Windows (x86/x86_64) с использованием MSVC
      add_library(sqlite3 SHARED ${SQLITE_SOURCE_FILES})
  ```

- **Linux (x86/x86_64)  – только so при помощи gcc**

  ```cmake
  elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")
      # Для Linux (x86/x86_64) с использованием GCC
      set(CMAKE_C_COMPILER gcc)
      set(CMAKE_CXX_COMPILER gcc)
      add_library(sqlite3 SHARED ${SQLITE_SOURCE_FILES})
      target_link_libraries(sqlite3 dl pthread)
  ```

  

## 2. Создать Docker и предоставить Dockerfile для инициализации легковесного сборочного окружения с gcc, в котором можно собрать so.

```dockerfile
# Используем Alpine Linux как базовый образ

FROM alpine:latest

# Обновляем пакетный менеджер и устанавливаем необходимые зависимости

RUN apk update && apk add --no-cache \
    build-base \
    gcc \
    libc-dev \
    make

# Устанавливаем рабочую директорию

WORKDIR /app

# Копируем исходные файлы sqlite

COPY sqlite-amalgamation-3260000/sqlite3.c /app/
COPY sqlite-amalgamation-3260000/sqlite3ext.h /app/

# Собираем

RUN gcc -shared -o libsqlite3.so -fPIC sqlite3.c

# Очищаем установленные зависимости, чтобы уменьшить размер образа

RUN apk del build-base

# Предоставляем команду для запуска образа

CMD ["/bin/sh"]
```



Построить образ

```bash
docker build -t sqlite-builder .
```

Запустить контейнер

```bash
docker run -it --rm sqlite-builder
```



## 3. Подготовить автоматизированно, используя на выбор одно из средств: vboxmanage/vagrant/packer, виртуальную машину c операционной системой GNU/Linux и дистрибутивом CentOS 7 в среде VirtualBox.  

**paker json:**

```json
{
  "builders": [
    {
      "iso_checksum": "sha256:07b94e6b1a0b0260b94c83d6bb76b26bf7a310dc78d7a9c74>
      "iso_url": "http://mirror.linux-ia64.org/centos/7.9.2009/isos/x86_64/Cent>
      "type": "virtualbox-iso",
      "ssh_username": "vagrant"
    }
  ],
  "post-processors": [
    {
      "compression_level": 6,
      "output": "centos7.box",
      "type": "vagrant"
    }
  ],
  "provisioners": [
    {
      "execute_command": "echo 'vagrant'|{{.Vars}} sudo -S -E bash '{{.Path}}'",
      "script": "scripts/base.sh",
      "type": "shell"
    }
  ]
}
```



**Скрипт после создания образа:**

```bash
#!/bin/bash

# Установка дополнительных пакетов

sudo yum install -y epel-release
sudo yum install -y gcc make kernel-devel kernel-headers dkms perl

# Установка VirtualBox Guest Additions

sudo mount -o loop,ro /home/vagrant/VBoxGuestAdditions.iso /mnt
sudo sh /mnt/VBoxLinuxAdditions.run
sudo umount /mnt

# Очистка

sudo yum clean all
sudo rm -rf /var/cache/yum
sudo rm -f /home/vagrant/VBoxGuestAdditions.iso

# default креды

echo 'vagrant:vagrant' | chpasswd
```



## 4. Подготовить Bash скрипт, который устанавливает на созданную вами виртуальную машину Docker.

скрипт который устанавливает docker на centos.

```bash
#!/bin/bash

# Обновляем пакеты

sudo yum update -y

# Устанавливаем необходимые зависимости

sudo yum install -y yum-utils device-mapper-persistent-data lvm2

# Добавляем официальный репозиторий Docker

sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/doc>

# Устанавливаем Docker

sudo yum install -y docker-ce docker-ce-cli containerd.io

# Запускаем Docker и добавляем его в автозагрузку

sudo systemctl start docker
sudo systemctl enable docker

# Добавляем текущего пользователя в группу docker, чтобы избежать использования>

sudo usermod -aG docker $USER

# Выводим сообщение об успешной установке

echo "Docker успешно установлен и настроен на этой виртуальной машине."
```



## 5. Подготовить Bash скрипт, который выполняет пункты 1, 3b (с запуском компилятора и получением лога/библиотеки), 4.

```bash
#!/bin/bash

# Установка утилит для загрузки и распаковки

sudo yum install -y wget unzip

# Загрузка архива с исходниками SQLite

wget https://www.sqlite.org/2018/sqlite-amalgamation-3260000.zip

# Распаковка архива

unzip sqlite-amalgamation-3260000.zip

# Компиляция исходников и создание shared library (.so)

gcc -shared -o libsqlite3.so -fPIC sqlite-amalgamation-3260000/sqlite3.c

# Запуск Docker (предполагается, что Docker установлен), а так же

# Dockerfile находится рядом

docker run -it --rm -v $(pwd):/app sqlite-builder

# Очистка временных файлов

rm -rf sqlite-amalgamation-3260000*

echo "Компиляция успешно завершена. Библиотека libsqlite3.so создана."
```



## 6. Подготовить простую исполняемую программу на C++, которая использует любую стороннюю зависимость, доступную для пакетного менеджера Conan. Реализовать пример сборки бинарного файла этой программы с использованием Conanfile (Python), а также CMake и любого компилятора в ОС Linux. 	



Файлы прикреплены.