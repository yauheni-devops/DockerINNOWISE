# 1. Берем базовый образ
FROM fluent/fluentd:v1.15-1

# 2. Переключаемся на root, чтобы иметь права на установку
USER root

# 3. ОБНОВЛЯЕМ сам установщик 'gem'
RUN gem update --system

# 4. Устанавливаем КОНКРЕТНУЮ ВЕРСИЮ плагина (4.4.1)
RUN gem install fluent-plugin-elasticsearch -v 4.4.1

# 5. Возвращаемся к стандартному пользователю 'fluent' для безопасности
USER fluent
```

---

### Что делать дальше

1.  **Сохраните** этот файл.
2.  **Пересоберите `fluentd`:**
    ```bash
    docker-compose -p rbm31 build fluentd
    ```
    (Теперь вы должны увидеть `[3/3] RUN gem install...`)

3.  **Запустите все:**
    ```bash
    docker-compose -p rbm31 up -d