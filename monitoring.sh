#!/bin/bash

PROCESS_NAME="test"
URL="https://test.com/monitoring/test/api"
LOG_FILE="/var/log/monitoring.log"

write_log() {
    local message=$1
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$timestamp - $message" >> $LOG_FILE
    echo "Записано в лог: $message"
}

check_process() {
    if pgrep -x "$PROCESS_NAME" > /dev/null; then
        echo "Процесс $PROCESS_NAME запущен"
        return 0
    else
        echo "Процесс $PROCESS_NAME не запущен"
        return 1
    fi
}

check_restart() {

    local current_pid=$(pgrep -x "$PROCESS_NAME")
    local pid_file="/tmp/test_process.pid"

    if [ -f "$pid_file" ]; then

        local old_pid=$(cat "$pid_file")

        if [ "$current_pid" != "$old_pid" ]; then
            write_log "ПРОЦЕСС ПЕРЕЗАПУЩЕН: Старый PID: $old_pid, Новый PID: $current_pid"
        fi
    fi
    echo "$current_pid" > "$pid_file"
}

send_request() {
    echo "Отправляю запрос на $URL"
    if curl -s -f "https://test.com/monitoring/test/api" > /dev/null; then
        echo "Запрос успешно отправлен"
        return 0
    else
        write_log "ОШИБКА: Сервер мониторинга недоступен"
        return 1
    fi
}

main() {
    echo "= ЗАПУСК МОНИТОРИНГА ="
    if check_process; then
        echo "Процесс найден, продолжаем..."
        check_restart
        send_request
    else
        echo "Процесс не запущен"
    fi
    echo "= МОНИТОРИНГ ВЫПОЛНЕН ="
    echo ""
}

main
