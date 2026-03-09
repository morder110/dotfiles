#!/bin/bash

# TODO: When exiting to Ly, this must be terminated

notified=false
while true; do
    memory=$(free -m)
    total_memory=$(awk 'NR==2 {print $2}' <<< "$memory")
    high_memory_usage=$(( total_memory / 100 * 80 )) # 80% of total memory

    used_memory=$(awk 'NR==2 {print $3}' <<< "$memory")

    if [[ "$used_memory" -ge "$high_memory_usage" ]]; then
        if [[ "$notified" == false ]]; then
            # TODO: Ensure this icon exists.
            notify-send -u "critical" -i "$HOME/.assets/icons/misc/warning.png" \
                "Warning!" "80% of memory used: $used_memory MB in use"
            notified=true
        fi
    else
        notified=false
    fi

    # Sleep to reduce CPU usage
    sleep 5
done