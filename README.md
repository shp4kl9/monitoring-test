Установка


sudo cp monitoring.sh /usr/local/bin/

sudo chmod +x /usr/local/bin/monitoring.sh

sudo touch /var/log/monitoring.log


Настройка systemd

sudo cp monitoring.service monitoring.timer /etc/systemd/system/

sudo systemctl daemon-reload

sudo systemctl enable monitoring.timer

sudo systemctl start monitoring.timer


Ручной запуск

/usr/local/bin/monitoring.sh


Проверка таймера

sudo systemctl status monitoring.timer


Проверка логов

tail -f /var/log/monitoring.log

