#!/usr/bin/env bash

jq_format_csv() {
    echo "$1" | jq -r '
        ["id", "start", "end", "duration", "quarter_hours", "tags", "annotation"],
        (.[] |
            .end = (.end // (now | strftime("%Y%m%dT%H%M%SZ"))) |
            .duration = ((.end | strptime("%Y%m%dT%H%M%SZ") | mktime) - (.start | strptime("%Y%m%dT%H%M%SZ") | mktime)) |
            .quarter_hours = (.duration / 3600 / 0.25 | ceil * 0.25) |
            [
                .id,
                (.start | strptime("%Y%m%dT%H%M%SZ") | mktime | todateiso8601),
                (.end | strptime("%Y%m%dT%H%M%SZ") | mktime | todateiso8601),
                (.duration | strftime("%T")),
                .quarter_hours,
                (.tags | join(", ")),
                .annotation
            ]
        ) | @csv
    '
}

jq_format_csv "$(timew export "$@")"

exit 0
