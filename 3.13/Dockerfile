FROM ubuntu:22.04
ENV testenv1=env1
#создадим пользователя
RUN groupadd --gid 2000 user && useradd --uid 2000 --gid 2000 --shell /bin/bash --create-home user
#Посмотрим состояние кэша apt до установки nginx - ЭТО ДЛЯ ДЕМОНСТРАЦИИ, В РЕАЛЬНОМ ФАЙЛЕ МОЖНО УДАЛИТЬ
RUN ls -lah /var/lib/apt/lists/

# ОБЪЕДИНЕННАЯ КОМАНДА: Установка и очистка в одном слое
RUN apt-get update -y && apt-get install nginx -y && rm -rf /var/lib/apt/lists/*

#Повторно проверим состояние кэша apt - ЭТО ДЛЯ ДЕМОНСТРАЦИИ
RUN ls -lah /var/lib/apt/lists/

# ОПТИМИЗИРОВАННОЕ КОПИРОВАНИЕ: Сразу назначаем владельца
COPY --chown=user:user testfile .

# Директива RUN chown... больше не нужна

USER user
CMD ["sleep infinity"]