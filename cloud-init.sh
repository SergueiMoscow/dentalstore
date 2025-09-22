#!/bin/bash

set -e  # Прерывать выполнение при ошибке

# Переменные
ADMIN_USERNAME="admin"
ADMIN_PASSWORD_HASH='$6$EFOMZg8yuMMFHQV8$geCsvLs3Z6Fy2LaFrMfEnAt0QhnY.3BRA807Rp24aB1gVjQGILjm0phYSiuCGmUOhSA5d.hiLlkgR6dVPHAXx1'

# Функция для вывода сообщений
function echo_info {
    echo -e "\e[32m[INFO]\e[0m $1"
}

function echo_warn {
    echo -e "\e[33m[WARNING]\e[0m $1"
}

function echo_error {
    echo -e "\e[31m[ERROR]\e[0m $1"
}

# Проверка привилегий root
if [[ "$EUID" -ne 0 ]]; then
   echo_error "Пожалуйста, запустите этот скрипт с правами root (используйте sudo)."
   exit 1
fi

echo_info "Установка необходимых пакетов..."
apt install -y software-properties-common git
add-apt-repository ppa:deadsnakes/ppa -y
apt update -y
sudo apt install -y python3.11


echo_info "Обновление установленных пакетов..."
apt upgrade -y

# Проверка наличия группы docker, создание при необходимости
if ! getent group docker >/dev/null; then
    echo_info "Создание группы 'docker'..."
    groupadd docker
else
    echo_info "Группа 'docker' уже существует. Пропуск создания."
fi

# Проверка наличия пользователя admin
if id "$ADMIN_USERNAME" &>/dev/null; then
    echo_warn "Пользователь '$ADMIN_USERNAME' уже существует. Пропуск создания."
else
    echo_info "Создание пользователя '$ADMIN_USERNAME'..."
    useradd -m -s /bin/bash -p "$ADMIN_PASSWORD_HASH" "$ADMIN_USERNAME"
fi

# Добавление пользователя в группы sudo и docker
echo_info "Добавление пользователя '$ADMIN_USERNAME' в группы 'sudo' и 'docker'..."
usermod -aG sudo,docker "$ADMIN_USERNAME"

# Настройка passwordless sudo для admin
SUDOERS_FILE="/etc/sudoers.d/$ADMIN_USERNAME"
if [ ! -f "$SUDOERS_FILE" ]; then
    echo_info "Настройка passwordless sudo для пользователя '$ADMIN_USERNAME'..."
    echo "$ADMIN_USERNAME ALL=(ALL) NOPASSWD:ALL" > "$SUDOERS_FILE"
    chmod 440 "$SUDOERS_FILE"
else
    echo_info "Файл sudoers для пользователя '$ADMIN_USERNAME' уже существует. Пропуск настройки."
fi

# Установка Docker
echo_info "Скачивание и установка Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
rm get-docker.sh

# Убедиться, что admin добавлен в группу docker (на всякий случай)
echo_info "Проверка принадлежности пользователя '$ADMIN_USERNAME' к группе 'docker'..."
usermod -aG docker "$ADMIN_USERNAME"

# Перезагрузка службы Docker для применения изменений
echo_info "Перезапуск Docker службы..."
systemctl restart docker

echo_info "Инициализация сервера завершена."
