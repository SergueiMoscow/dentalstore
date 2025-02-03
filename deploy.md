# Инструкция по развёртыванию приложения
## Подготовка сервера

Для повышения безопасности рекомендуется выполнять все действия от имени обычного пользователя с повышенными привилегиями через `sudo`. Ниже представлены два варианта автоматической подготовки сервера для развёртывания приложения.

### Создание пользователя
При создании сервера создаётся пользователь с ограниченными привилегиями. После создания рекомендуется изменить пароль созданного пользователя. Хеш пароля соответствует `ChangeMe`.

Для создания хеша пароля используйте команду:
```bash
openssl passwd -6 "MySecurePassword"
```
Сохраните полученный хеш для дальнейшего использования в конфигурации.

### Вариант 1 Использование [`cloud-init`](cloud-init.yml)
Перед созданием сервера укажите файл конфигурации [cloud-init](cloud-init.yml).

Если требуется сменить имя пользователя, замените `admin` на нужное имя. Также замените параметр `passwd` на хеш устанавливаемого пароля.

```yml
 - name: admin
   sudo: ['ALL=(ALL) NOPASSWD:ALL']
   groups: sudo, docker
   shell: /bin/bash
   lock_passwd: false
   passwd: "$6$EFOMZg8yuMMFHQV8$geCsvLs3Z6Fy2LaFrMfEnAt0QhnY.3BRA807Rp24aB1gVjQGILjm0phYSiuCGmUOhSA5d.hiLlkgR6dVPHAXx1"
```
После создания сервера вы можете проверить статус выполнения скриптов `cloud-init` командой:
```bash
cat /var/log/cloud-init-output.log
```

### Вариант 2 Запуск скрипта из консоли [cloud-init.sh](cloud-init.sh).
Откройте файл [cloud-init.sh](cloud-init.sh) и измените следующие строки для смены имени и пароля пользователя:
```bash
ADMIN_USERNAME="admin"
ADMIN_PASSWORD_HASH='$6$EFOMZg8yuMMFHQV8$geCsvLs3Z6Fy2LaFrMfEnAt0QhnY.3BRA807Rp24aB1gVjQGILjm0phYSiuCGmUOhSA5d.hiLlkgR6dVPHAXx1'
```

### Устанавливаемые пакеты:
- sudo
- curl
- git
- ca-certificates
- python3.11
- python3.11-venv
- python3.11-dev
- docker

## Установка приложения
1. Склонировать код проекта: `git clone https://github.com/a-krasilskaya/dentalstore`
2. Создать .env файл конфигурации. Пример: [.env](env.example)
3. Запустить `docker compose up -d`
4. Открыть в браузере <ip>:9000 и задать пароль для portainer
5. Если нужно подгрузить данные из дампа БД, то это можно сделать так:

`pg_restore --no-owner -U <user> -d <database> -h <host> <path/to/dump_file>`

В зависимости от дампа, возможно, придётся удалить созданную миграциями БД, возможно, даже и схему.

Управлять (пересоздавать, перезапускать, останавливать) и мониторить (смотреть доступность, логи) контейнеры можно из portainer по адресу http://<your_ip>:9000
