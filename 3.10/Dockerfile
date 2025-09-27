# Параметризуем версию nginx через ARG
ARG NG_VERSION=latest
# Указываем базовый образ с использованием ARG
FROM nginx:$NG_VERSION

# Устанавливаем ENV из ARG
ENV NG_VERSION=$NG_VERSION

# Объявляем ARG для имени файла, который не будет сохранен в ENV
ARG ARG_FILE
# Создаем файл в /opt/ с именем из ARG_FILE
RUN touch /opt/$ARG_FILE
