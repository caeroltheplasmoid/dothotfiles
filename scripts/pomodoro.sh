#!/bin/bash

pomodoro_state_file="/tmp/pomodoro_state.txt"
notify_end_sent_status=0

function refresh_state_variables() {
    notify_end_sent_status=0
}

function clear_others_pomo() {
    lst_pomo_pid=$(cat /tmp/pomodoro_state.txt | grep -o '[0-9]\+' | tail -1)
    echo "lst_pomo_pid: $lst_pomo_pid"
    # get process by pid 
    if [ "$lst_pomo_pid" ]; then
        # kill nohup 
        kill -9 $lst_pomo_pid &
    fi;
}

function init_pomodoro() {
    refresh_state_variables
    clear_others_pomo

    local duration=$1
    echo "Pomodoro started! Work for $duration minutes."
    echo "work $duration $$" > "$pomodoro_state_file"
    
    notify-send 'Pomodoro' -c pomodoro "Pomodoro started! Work for $duration minutes."

    sleep "${duration}m"  # Sleep for the specified duration (in minutes)
    echo "Pomodoro completed! Take a break."
    stop_pomodoro
}

function stop_pomodoro() {
    echo "Pomodoro stopped!"
    rm -f "$pomodoro_state_file"
    notify-send 'Pomodoro' -c pomodoro "Pomodoro stopped!"
}

function check_pomodoro_state() {
    if [ -e "$pomodoro_state_file" ]; then

        # Calculate remaining time
        start_time=$(stat -c %Y "$pomodoro_state_file")
        duration=$(cat /tmp/pomodoro_state.txt | grep -o '[0-9]\+' | head -1)
        end_time=$(($start_time + $duration * 60))
        current_time=$(date +%s)
        remaining_seconds=$((end_time - current_time))

        # Notify if remaining time is less than 5 minutes
        # if [ $remaining_seconds -le 60 && $notify_end_sent_status -eq 0 ]; then
        #     notify_end_sent_status=1;
        #     notify-send 'Pomodoro' -c pomodoro "Time remaining: $remaining_minutes minutes $remaining_seconds seconds."
        # fi

        remaining_minutes=$((remaining_seconds / 60))
        remaining_seconds=$((remaining_seconds - remaining_minutes*60))
        
        printf '{"text": " Stay focused %02d:%02d"}' "$remaining_minutes" "$remaining_seconds"
    else
        printf '{"text": "Focus ", "class": "paused"}'
    fi
}

case "$1" in
    "toggle")
        echo "toggle"
        if [ -e "$pomodoro_state_file" ]; then
            clear_others_pomo 
            stop_pomodoro
        else 
            init_pomodoro 25
        fi
        ;;
    "start")
        if [ -z "$2" ]; then
            echo "Please provide the Pomodoro duration in minutes."
            exit 1
        fi
        init_pomodoro "$2"
        ;;
    "stop")
        stop_pomodoro
        ;;
    "status")
        check_pomodoro_state
        ;;
    *)
        echo "Usage: $0 {start <duration>|stop|status}"
        exit 1
        ;;
esac
