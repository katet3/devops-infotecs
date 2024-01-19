#!/bin/bash

# Установка зависимостей
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Добавление ключа GPG для официального репозитория Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Установка стабильной версии Docker
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Добавление текущего пользователя в группу docker, чтобы не использовать sudo для выполнения команд Docker
sudo usermod -aG docker $USER

# Перезапуск службы Docker
sudo service docker restart

echo "Docker установлен успешно. Перезапустите сеанс или выполните 'newgrp docker', чтобы применить изменения в группах."
