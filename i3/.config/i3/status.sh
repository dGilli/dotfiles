#!/bin/bash

date_formatted=$(date "+%H:%M %d")

battery_info=$(upower --show-info $(upower --enumerate |\
    grep 'BAT') |\
    grep -E "state|percentage" |\
    awk '/state:/ {state=$2} /percentage:/ {percentage=$2} END {\
        if (state == "fully-charged") {print "(fully-charged)"} \
        else {print percentage, "("state")"}}')

audio_volume=$(amixer -M get Master |\
    awk '/Mono:/{getline; \
        if ($6 == "[off]") print "(muted)"; \
        else {gsub(/\[|\]/, "", $5); print $5}}')

net_info=$(nmcli | awk 'NR==1')

temperature=$(cat /sys/class/thermal/thermal_zone*/temp | awk '{print $1/1000 "C"}' | sed -n '6p')

echo $net_info $audio_volume $temperature $battery_info $date_formatted
