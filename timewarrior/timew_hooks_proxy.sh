#!/usr/bin/env bash

notify_state_change() {
    local tracked_item="$1"
    sketchybar --trigger timew_state_change INFO="$tracked_item"
}

handle_hooks() {
    local cmd="$1"
    shift

    case "$cmd" in
        "start" | "continue" | "tag" | "track" | "untag")
            local tracked_item
            tracked_item=$(timew | head -n1 | sed -E 's/Tracking "(.+)"/\1/')
            notify_state_change "$tracked_item"
            ;;
        "cancel" | "stop")
            notify_state_change ""
            ;;
        *)
            ;;
    esac
}

TIMEW_BIN="$1"
shift

"$TIMEW_BIN" "$@"
exit_code=$?

handle_hooks "$@"

exit $exit_code
