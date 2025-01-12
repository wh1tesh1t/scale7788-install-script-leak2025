#!/bin/bash


WEB_SERVER="nginx"    # nginx/apache
FASTDL_DIR="/home/user/fastdl"
DOMAIN_OR_IP="ip_domain"


if ! command -v wget &> /dev/null; then
    echo "Утилита wget не установлена. Пожалуйста, установите ее."
    exit 1
fi


if [[ "$WEB_SERVER" == "nginx" ]]; then
    if ! command -v nginx &> /dev/null; then
        echo "Устанавливаем Nginx..."
        sudo apt update
        sudo apt install nginx -y
    fi
    # Настройка Nginx
    CONF_FILE="/etc/nginx/sites-available/fastdl"
    echo "Создаем конфигурацию Nginx..."
    cat <<EOF >"$CONF_FILE"
server {
    listen 80;
    server_name $DOMAIN_OR_IP;

    root $FASTDL_DIR;

    index index.html;
}
EOF
    ln -s "$CONF_FILE" /etc/nginx/sites-enabled/fastdl
    sudo systemctl restart nginx
elif [[ "$WEB_SERVER" == "apache" ]]; then
  if ! command -v apache2 &> /dev/null; then
      echo "Устанавливаем Apache..."
      sudo apt update
      sudo apt install apache2 -y
  fi
  CONF_FILE="/etc/apache2/sites-available/fastdl.conf"
  echo "Создаем конфигурацию Apache..."
    cat <<EOF >"$CONF_FILE"
<VirtualHost *:80>
    ServerName $DOMAIN_OR_IP
    DocumentRoot $FASTDL_DIR

    <Directory $FASTDL_DIR>
      Options Indexes FollowSymLinks
      AllowOverride None
      Require all granted
    </Directory>

</VirtualHost>
EOF
  sudo a2ensite fastdl.conf
  sudo systemctl restart apache2
else
  echo "Веб-сервер не поддерживается"
  exit 1
fi

echo "Создаем каталог $FASTDL_DIR"
mkdir -p "$FASTDL_DIR"

echo "Done! Web FastDL Address http://$DOMAIN_OR_IP"

# 40% code From randomly cs 1.6 vps
# enjoy!
# Leak by w_sh1t