# ---- ЭТАП 1: "Сборщик" (Builder) ----
# ИСПРАВЛЕНО: Используем версию Go 1.23, как того требуют зависимости
FROM golang:1.23-alpine AS builder

WORKDIR /app

# 1. Копируем go.mod и go.sum ПЕРВЫМИ
COPY go.mod go.sum ./

# 2. Загружаем зависимости (это будет кэшироваться)
RUN go mod download

# 3. Копируем остальной исходный код (включая main.go)
COPY . .

# 4. Компилируем приложение
RUN CGO_ENABLED=0 go build -o /gocalc main.go

# ---- ЭТАП 2: "Финальный" (Runner) ----
FROM alpine:latest

WORKDIR /app

# Копируем ТОЛЬКО скомпилированный файл из "builder"
COPY --from=builder /gocalc .

# Команда для запуска приложения
CMD ["./gocalc"]