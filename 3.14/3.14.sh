#!/bin/bash
set -e # Прерывать выполнение скрипта при любой ошибке

# --- ЧАСТЬ 1: РАБОТА С GOCALC ---

echo "--- Шаг 1: Клонирование репозитория gocalc ---"
if [ -d "gocalc" ]; then
    echo "Директория gocalc уже существует. Пропускаем клонирование."
else
    # ИЗМЕНЕНИЕ: Добавлен флаг '-c credential.helper=' для временного отключения
    # менеджера учетных данных VS Code, который вызывает ошибку.
    git -c credential.helper= clone https://github.com/Dmitry-dms/gocalc.git
fi
cd gocalc
echo

echo "--- Шаг 2: Создание Dockerfile для gocalc (с именованным этапом) ---"
# Используем cat с HEREDOC для создания файла
cat > Dockerfile << 'EOF'
# Этап 1: Сборщик (Builder)
FROM golang:1.19.1-alpine AS builder
WORKDIR /go/src/gocalc
COPY . .
ENV GO111MODULE=auto
RUN go get
RUN go build -o app

# Этап 2: Исполнение (Runner)
FROM alpine:3.10.3
WORKDIR /app
COPY --from=builder /go/src/gocalc/app .
ENTRYPOINT ["./app"]
EOF
echo "Dockerfile создан:"
cat Dockerfile
echo

echo "--- Шаг 3: Сборка образа gocalc:v1 ---"
docker build -t gocalc:v1 .
echo

echo "--- Шаг 4: Вывод списка образов и истории ---"
echo ">>> Список образов:"
docker images | grep gocalc
echo
echo ">>> История образа gocalc:v1:"
docker history gocalc:v1
echo

echo "--- Шаг 5: Модификация Dockerfile (без именованного этапа) ---"
cat > Dockerfile << 'EOF'
# Этап 1: Сборщик (Builder) - теперь без имени "AS builder"
FROM golang:1.19.1-alpine
WORKDIR /go/src/gocalc
COPY . .
ENV GO111MODULE=auto
RUN go get
RUN go build -o app

# Этап 2: Исполнение (Runner)
FROM alpine:3.10.3
WORKDIR /app
# Копируем из первого этапа, используя его индекс (0)
COPY --from=0 /go/src/gocalc/app .
ENTRYPOINT ["./app"]
EOF
echo "Dockerfile модифицирован для использования индекса:"
cat Dockerfile
echo

echo "--- Шаг 6: Сборка образа gocalc:v2 из модифицированного файла ---"
docker build -t gocalc:v2 .
echo "Сборка gocalc:v2 завершена."
echo

echo "--- Шаг 7: Добавление ARG с секретом в Dockerfile ---"
cat > Dockerfile << 'EOF'
# Этап 1: Сборщик (Builder)
FROM golang:1.19.1-alpine
WORKDIR /go/src/gocalc
COPY . .
ENV GO111MODULE=auto
RUN go get
RUN go build -o app

# Этап 2: Исполнение (Runner)
FROM alpine:3.10.3
# Объявляем ARG, чтобы его значение было доступно на этом этапе
ARG MY_SECRET
WORKDIR /app
COPY --from=0 /go/src/gocalc/app .
# Записываем значение секрета в файл. Используем кавычки для корректной обработки.
RUN echo "Секрет: ${MY_SECRET}" > secret.txt
ENTRYPOINT ["./app"]
EOF
echo "Dockerfile модифицирован для использования секрета:"
cat Dockerfile
echo

echo "--- Шаг 8: Сборка образа gocalc:v3 с передачей секрета ---"
docker build --build-arg MY_SECRET="very-secret-value-123" -t gocalc:v3 .
echo

echo "--- Шаг 9: Проверка наличия секрета в контейнере ---"
echo "Запускаем контейнер и читаем файл secret.txt. Ожидаемый вывод: 'Секрет: very-secret-value-123'"
docker run --rm gocalc:v3 cat secret.txt
echo
cd ..

# --- ЧАСТЬ 2: РАБОТА С GRAFANA ---

echo "--- Шаг 10: Клонирование репозитория Grafana (ветка v6.3.x) ---"
if [ -d "grafana" ]; then
    echo "Директория grafana уже существует. Пропускаем клонирование."
else
    # ИЗМЕНЕНИЕ: Также добавляем флаг сюда для консистентности.
    git -c credential.helper= clone --depth 1 --branch v6.3.x https://github.com/grafana/grafana.git
fi
cd grafana
echo

echo "--- Шаг 11: Создание Dockerfile для Grafana с двумя целевыми образами ---"
# Примечание: оригинальный Dockerfile в Grafana очень сложен.
# Мы создаем новый, упрощенный Dockerfile, который демонстрирует требуемую концепцию.
cat > Dockerfile << 'EOF'
# Этап 1: Сборка приложения (симуляция)
FROM alpine:3.10.3 AS grafana-app-builder
WORKDIR /go/src/github.com/grafana/grafana
RUN mkdir -p public/js public/css bin && \
    echo "console.log('grafana app');" > public/js/app.js && \
    echo "body { background: #222; }" > public/css/main.css && \
    echo "#!/bin/sh" > bin/grafana-server && \
    echo "echo 'Starting Grafana Server...'" >> bin/grafana-server && \
    chmod +x bin/grafana-server

# Этап 2: Финальный образ для самого приложения Grafana
FROM alpine:3.10.3 AS grafana-app
WORKDIR /usr/share/grafana
COPY --from=grafana-app-builder /go/src/github.com/grafana/grafana/bin/grafana-server .
COPY --from=grafana-app-builder /go/src/github.com/grafana/grafana/public ./public
ENTRYPOINT ["./grafana-server"]

# Этап 3: Финальный образ для раздачи статики через Nginx
FROM nginx:alpine AS grafana-static
COPY --from=grafana-app-builder /go/src/github.com/grafana/grafana/public /usr/share/nginx/html
EOF
echo "Dockerfile для Grafana создан:"
cat Dockerfile
echo

echo "--- Шаг 12: Сборка целевых образов Grafana по отдельности ---"
echo ">>> Собираем образ приложения grafana:app (цель: grafana-app)"
docker build --target grafana-app -t grafana:app .
echo
echo ">>> Собираем образ для статики grafana:static (цель: grafana-static)"
docker build --target grafana-static -t grafana:static .
echo

echo "--- Шаг 13: Вывод списка образов Grafana ---"
docker images | grep "grafana"
echo

echo "--- Все шаги выполнены успешно! ---"
cd ..

