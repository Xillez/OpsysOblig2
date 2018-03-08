#!/bin/bash

PID_LIST=$(pgrep "chrome")

echo "$(pgrep code)" | while read item; do
    PF_PID=$(ps --no-headers -o maj_flt $item)
    
    if [[ $PF_PID -gt 1000 ]]; then
        echo -n "Pid $item generated $PF_PID page faults (over 1000)!!
"
    else
        echo -n "Pid $item generated $PF_PID page faults!
"
    fi
done