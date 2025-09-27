# Использовать актуальный образ Ubuntu
FROM ubuntu:22.04

# Установить Nginx
RUN apt-get update && apt-get install -y nginx

# ❗️ FIX 1: Создать директорию для логов
RUN mkdir -p /var/log/nginx

# ❗️ FIX 2: Создать директорию для PID-файла
RUN mkdir -p /var/run

# Скопировать конфигурацию
COPY nginx.conf /etc/nginx/nginx.conf

# Установить рабочую директорию
WORKDIR /etc/nginx/

# Определить том
VOLUME /var/lib/nginx

# Задать точку входа и команду
ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]