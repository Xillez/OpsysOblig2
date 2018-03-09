#!/bin/bash

for PID in "$@"
do
    # Ready the file name and set of Values to search for inside "/proc/$PID/status"
    FILE_NAME="$PID-$(date +%d%m%y).meminfo"
    ITEM_NAMES=("VmSize" "VmData" "VmStk" "VmExe" "VmLib" "VmRSS" "VmPTE")

    # Declare an associative array called "ITEM_VALUES"
    declare -A ITEM_VALUES

    # Loop through all items in "ITEM_NAMES" and find them in "/proc/$PID/status"
    i=0
    for item in "${ITEM_NAMES[@]}"
    do
        # Find the item value (from "/proc/$PID/status") and save it (in "ITEM_VALUES")
        ITEM_VALUES[$item]=$(grep "${ITEM_NAMES[i]}" "/proc/$PID/status" | awk '{ print $2 }')
        ((i++))
    done

    # Format file output and dump it to file
    echo "******** Minne info om prosess med PID $PID ********
Total bruk av virtuelt minne (VmSize):   ${ITEM_VALUES[${ITEM_NAMES:0}]} KB
Mengde privat virtuelt minne (VmData+VmStk+VmExe):  $(echo "${ITEM_VALUES[${ITEM_NAMES[1]}]} + ${ITEM_VALUES[${ITEM_NAMES[2]}]} + ${ITEM_VALUES[${ITEM_NAMES[3]}]}" | bc) KB
Mengde shared virtuelt minne (VmLib):   ${ITEM_VALUES[${ITEM_NAMES[4]}]} KB
Total bruk av fysisk minne (VmRSS):   ${ITEM_VALUES[${ITEM_NAMES[5]}]} KB
Mengde fysisk minne som benyttes til page table (VmPTE):   ${ITEM_VALUES[${ITEM_NAMES[6]}]} KB" > "$FILE_NAME"
done