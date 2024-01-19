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
# CMD tail -f /dev/null
