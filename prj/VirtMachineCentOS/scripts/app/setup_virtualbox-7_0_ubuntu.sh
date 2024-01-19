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
    if eval $1; then
        echo "Действие уже выполнено, пропускаем: $1"
        return 0
    else
        return 1
    fi
}

# Обновление пакетов
execute_command "sudo apt update"

# Загрузка и добавление ключей Oracle
check_command "sudo test -f /etc/apt/trusted.gpg.d/oracle_vbox_2016.gpg"
if [ $? -ne 0 ]; then
    execute_command "curl https://www.virtualbox.org/download/oracle_vbox_2016.asc | gpg --dearmor > oracle_vbox_2016.gpg"
    execute_command "sudo install -o root -g root -m 644 oracle_vbox_2016.gpg /etc/apt/trusted.gpg.d/"
fi

check_command "sudo test -f /etc/apt/trusted.gpg.d/oracle_vbox.gpg"
if [ $? -ne 0 ]; then
    execute_command "curl https://www.virtualbox.org/download/oracle_vbox.asc | gpg --dearmor > oracle_vbox.gpg"
    execute_command "sudo install -o root -g root -m 644 oracle_vbox.gpg /etc/apt/trusted.gpg.d/"
fi

# Добавление репозитория VirtualBox
check_command "sudo test -f /etc/apt/sources.list.d/virtualbox.list"
if [ $? -ne 0 ]; then
    execute_command "echo \"deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib\" | sudo tee /etc/apt/sources.list.d/virtualbox.list"
    execute_command "sudo apt update"
fi

# Установка зависимостей и VirtualBox
check_command "dpkg -l | grep virtualbox-7.0"
if [ $? -ne 0 ]; then
    execute_command "sudo apt install -y linux-headers-$(uname -r) dkms"
    execute_command "sudo apt install virtualbox-7.0 -y"
fi

# Загрузка и установка Extension Pack
check_command "test -f Oracle_VM_VirtualBox_Extension_Pack-7.0.0.vbox-extpack"
if [ $? -ne 0 ]; then
    execute_command "wget https://download.virtualbox.org/virtualbox/7.0.0/Oracle_VM_VirtualBox_Extension_Pack-7.0.0.vbox-extpack"
    execute_command "sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-7.0.0.vbox-extpack"
fi

echo "Установка VirtualBox завершена успешно!"
