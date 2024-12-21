#!/bin/sh

getBytes() {
    netstat -w1 > ~/.config/sketchybar/plugins/network.out & sleep 1; kill $!
}

BYTES=$(getBytes > /dev/null)
BYTES=$(grep '[0-9].*' ~/.config/sketchybar/plugins/network.out)

DOWN=$(echo "$BYTES" | awk '{print $3}')
UP=$(echo "$BYTES" | awk '{print $6}')

human_readable() {
    bytes="${1}"
    precision="${2}"

    for factor in 1152921504606846976:EiB 1099511627776:TiB 1073741824:GiB 1048576:MiB 1024:KiB 1:B; do
        size_factor="${factor%:*}"
        abbrev="${factor#*:}"

        if [ "$bytes" -ge "$size_factor" ]; then
            # Calculate size using awk
            size=$(echo "$bytes $size_factor" | awk '{printf "%.2f", $1 / $2}')
            printf "%.*f %s\n" "$precision" "$size" "$abbrev"
            break
        fi
    done
}

DOWN_FORMAT=$(human_readable "$DOWN" 1)
UP_FORMAT=$(human_readable "$UP" 1)

sketchybar --set network.down label="$DOWN_FORMAT/s" \
	       --set network.up   label="$UP_FORMAT/s"
