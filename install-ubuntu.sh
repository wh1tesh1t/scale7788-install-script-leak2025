#!/bin/bash

apt update
apt install -y wget curl sudo vim

echo "Europe/Moscow" | tee /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata

echo "Введите имя пользователя:"
read username
adduser $username
usermod -aG sudo $username

echo "Введите порт SSH:"
read ssh_port
if [[ -z "$ssh_port" ]]; then
  ssh_port="22"
fi
sed -i "s/#Port 22/Port $ssh_port/g" /etc/ssh/sshd_config
systemctl restart ssh

sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
systemctl restart ssh

apt upgrade -y
apt autoremove -y

apt install -y ufw
ufw allow $ssh_port
ufw allow http
ufw allow https
ufw enable

echo "Установка Ubuntu завершена. Теперь перезагрузите VPS."
echo "Пользователь: $username"
echo "SSH порт: $ssh_port"

# Перезагрузка системы
# reboot

# Script not by me one guy write this script in 2024 i just fix sh1t
# Use only trusted scripts
# enjoy!
# Leak by w_sh1t
