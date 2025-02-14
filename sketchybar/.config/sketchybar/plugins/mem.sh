#!/usr/bin/env bash

m=$(memory_pressure | grep "System-wide memory free percentage:" | awk '{ print 100 - $5 }')

if [[ $m -ge 100 ]]; then
    m="1"
else
    m="0.$m"
fi

sketchybar --push "$NAME" "$m"

