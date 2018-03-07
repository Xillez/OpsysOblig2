echo "1 - Hvem er jeg og hva er navnet på dette scriptet?
2 - Hvor lenge er det siden siste boot?
3 - Hvor mange prosesser og tråder finnes?
4 - Hvor mange context switch'er fant sted siste sekund?
5 - Hvor stor andel av CPU-tiden ble benyttet i kernelmode og i usermode siste sekund?
6 - Hvor mange interrupts fant sted siste sekund?
9 - Avslutt dette scriptet

Velg en funksjon:"

# Print user name
echo "I am: $(whoami)"

# Print script file name
echo "Script name: $(basename "$0")"

# Print the time (in only seconds) since last boot
# Using awk here to split the input string on spaces and select only first element
echo "Time since last boot: $(awk -F'\ ' '{if ($1) print $1}' /proc/uptime)"

# Print nr of processes and threads
# Using -AL on ps to get both processes and threads and counts them with wc -l (counts nr of lines)
echo "Nr processes and threads: $(ps -AL --no-headers | wc -l)"

# Print nr of context switches across CPU
# Context switching info exsists in /proc/stat and the "ctxt" filed hold all context switches across the cpu
# Using grep to get nr context switches, and then using awk to select second param (splitting on spaces)
FIRST_CONT_SWITCH=$(grep ctxt /proc/stat | awk -F'\ ' '{if ($2) print $2}' $1)
sleep 1
SEC_CONT_SWITCH=$(grep ctxt /proc/stat | awk -F'\ ' '{if ($2) print $2}' $1)
RESULT=$(($SEC_CONT_SWITCH-$FIRST_CONT_SWITCH))
echo "Nr context switches across cpu: $RESULT"