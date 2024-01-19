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
