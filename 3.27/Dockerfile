# /home/localadmin/DockerINNOWISE/3.20/zookeeper/Dockerfile.alpine

# 1. Базовый образ
FROM openjdk:8-jdk-alpine

# 2. Устанавливаем переменные окружения для Maven
ENV MAVEN_VERSION=3.9.6
ENV MAVEN_HOME=/usr/share/maven
ENV PATH=$MAVEN_HOME/bin:$PATH

# 3. Устанавливаем curl, скачиваем и распаковываем Maven (с ИСПРАВЛЕННЫМ URL)
RUN apk add --no-cache curl && \
    mkdir -p $MAVEN_HOME && \
    curl -fsSL "https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" | tar -xzC /usr/share/maven --strip-components=1

# 4. Устанавливаем рабочую директорию
WORKDIR /app

# 5. Копируем исходный код проекта в контейнер
COPY . .

# 6. Собираем приложение, пропуская тесты
RUN mvn clean install -DskipTests