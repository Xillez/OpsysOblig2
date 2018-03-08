echo "
1 - Hvem er jeg og hva er navnet på dette scriptet?
2 - Hvor lenge er det siden siste boot?
3 - Hvor mange prosesser og tråder finnes?
4 - Hvor mange context switcher fant sted siste sekund?
5 - Hvor stor andel av CPU-tiden ble benyttet i kernelmode og i usermode siste sekund?
6 - Hvor mange interrupts fant sted siste sekund?
9 - Avslutt dette scriptet

Velg en funksjon:"

while read -r sel; do
    case $sel in
    1)
        # Print user name
        echo "I am: $(whoami)"

        # Print script file name
        echo "Script name: $(basename $0)"
        ;;
    2)
        # Print the time (in only seconds) since last boot
        # Using awk here to split the input string on spaces and select only first element
        echo "Time since last boot: $(awk -F'\ ' '{if ($1) print $1}' /proc/uptime)"
        ;;
    3)
        # Print nr of processes and threads
        # Using -AL on ps to get both processes and threads and counts them with wc -l (counts nr of lines)
        echo "Nr processes and threads: $(ps -AL --no-headers | wc -l)"
        ;;
    4)
        # Print nr of context switches across CPU
        # Context switching info exsists in /proc/stat and the "ctxt" field hold all context switches across the cpu
        # Using grep to get the line, and then using awk to select second column (splitting on spaces)
        FIRST_CONT_SWITCH=$(grep ctxt /proc/stat | awk '{ print $2 }')

        # Then sleep for 1 sec
        sleep 1

        # Fetch results again
        RESULT=$(($(grep ctxt /proc/stat | awk '{ print $2 }') - $FIRST_CONT_SWITCH))

        # Print result
        echo "Nr context switches across cpu: $RESULT"
        ;;
    5)
        # Use grep to find first cpu line which is the total of all cpu lines below it and use awk to get 2nd (userspace) and 4th (kernelspace) column
        FIRST_USER=$(grep cpu -m 1 /proc/stat | awk '{ print $2 }')
        FIRST_KERNEL=$(grep cpu -m 1 /proc/stat | awk '{ print $4 }')

        # Sleep for 1 sec
        sleep 1

        # Fetch results again using grep and awk
        DIFF_USER=$(( $(grep cpu -m 1 /proc/stat | awk '{ print $2 }') - $FIRST_USER ))
        DIFF_KERNEL=$(( $(grep cpu -m 1 /proc/stat | awk '{ print $4 }') - $FIRST_KERNEL ))

        # Divide time in kernel and user on total time in both, and get "bc" to calculate (for floats)
        # Then print the results
        echo "Usermode percentage: $(echo "scale=2; $DIFF_USER / (($DIFF_USER + $DIFF_KERNEL)) * 100" | bc)%"
        echo "Kernelmode percentage: $(echo "scale=2; $DIFF_KERNEL / (($DIFF_USER + $DIFF_KERNEL)) * 100" | bc)%"
        ;;
    6)
        # Print nr of interrupts across CPU
        # Interupt info exsists in /proc/stat and the "intr" field hold all context switches across the cpu
        # Using grep to get the line, and then using awk to select second column (splitting on spaces)
        FIRST_INTR=$(grep intr /proc/stat | awk '{ print $2 }')

        # Then sleep for 1 sec
        sleep 1

        # Fetch results again
        RESULT=$(($(grep intr /proc/stat | awk '{ print $2 }') - $FIRST_INTR))

        # Print result
        echo "Nr context switches across cpu: $RESULT"
        ;;
    9)
        exit 1
        ;;
    esac

    echo "
1 - Hvem er jeg og hva er navnet på dette scriptet?
2 - Hvor lenge er det siden siste boot?
3 - Hvor mange prosesser og tråder finnes?
4 - Hvor mange context switcher fant sted siste sekund?
5 - Hvor stor andel av CPU-tiden ble benyttet i kernelmode og i usermode siste sekund?
6 - Hvor mange interrupts fant sted siste sekund?
9 - Avslutt dette scriptet

Velg en funksjon:"

done