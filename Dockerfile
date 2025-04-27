# Базовый образ
FROM python:3.12-slim

# Установка системных зависимостей
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    chromium \
    chromium-driver \
    openjdk-17-jre-headless \
    curl \
    tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Установка Allure
RUN curl -o allure-2.13.8.tgz -Ls https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/2.13.8/allure-commandline-2.13.8.tgz && \
    tar -zxvf allure-2.13.8.tgz -C /opt/ && \
    ln -s /opt/allure-2.13.8/bin/allure /usr/bin/allure && \
    rm allure-2.13.8.tgz

# Создание рабочей директории
WORKDIR /usr/workspace

# Копирование файла зависимостей
COPY ./requirements.txt .

# Установка Python-зависимостей
RUN pip3 install --no-cache-dir -r requirements.txt

# Копирование остального кода
COPY . .

# Команда по умолчанию
CMD ["pytest", "-sv", "--alluredir=allure-results"]