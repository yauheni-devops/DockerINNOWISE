# Используем стабильную версию nginx как базовый образ
FROM nginx:stable
# Копируем наш локальный nginx.conf внутрь контейнера
# по пути /etc/nginx/nginx.conf, заменяя стандартный.
COPY nginx.conf /etc/nginx/nginx.conf