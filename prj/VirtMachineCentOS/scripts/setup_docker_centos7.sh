#!/bin/bash

# Обновляем пакеты
sudo yum update -y

# Устанавливаем необходимые зависимости
sudo yum install -y yum-utils device-mapper-persistent-data lvm2

# Добавляем официальный репозиторий Docker
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Устанавливаем Docker
sudo yum install -y docker-ce docker-ce-cli containerd.io

# Запускаем Docker и добавляем его в автозагрузку
sudo systemctl start docker
sudo systemctl enable docker

# Добавляем текущего пользователя в группу docker, чтобы избежать использования sudo при работе с Docker
sudo usermod -aG docker $USER

# Выводим сообщение об успешной установке
echo "Docker успешно установлен и настроен на этой виртуальной машине."
