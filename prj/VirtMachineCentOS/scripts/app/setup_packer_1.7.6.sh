#!/bin/bash

# Функция для выполнения команды с проверкой результата
execute_command() {
    $1
    if [ $? -ne 0 ]; then
        echo "Ошибка выполнения команды: $1"
        echo "Пожалуйста, устраните проблему и повторите попытку."
        exit 1
    fi
}

# Проверка выполнения команды
check_command() {
    if command -v $1 &> /dev/null; then
        echo "Команда $1 уже выполнена, пропускаем."
        return 0
    else
        return 1
    fi
}

# Установка Tor
check_command "tor"
if [ $? -ne 0 ]; then
    execute_command "sudo apt update"
    execute_command "sudo apt install -y tor"
fi

# Установка Packer
check_command "packer"
if [ $? -ne 0 ]; then
    # Попытка загрузки
    TOR_CMD="torsocks wget https://releases.hashicorp.com/packer/1.7.6/packer_1.7.6_linux_amd64.zip"
    execute_command "$TOR_CMD" || execute_command "wget https://releases.hashicorp.com/packer/1.7.6/packer_1.7.6_linux_amd64.zip"
    # Распаковка архива
    execute_command "unzip packer_1.7.6_linux_amd64.zip"

    # Перемещение в системный каталог
    execute_command "sudo mv packer /usr/local/bin/"

    # Проверка успешной установки
    execute_command "packer --version"
fi

echo "Установка Packer завершена успешно!"
