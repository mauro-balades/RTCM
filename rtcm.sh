#!/bin/bash

# # Start the command and capture its PID
$@ &> log &  # Execute the command passed as argument in the background
PID=$!       # Capture the PID of the command (i.e., the PID of the last background process)

touch info

# Loop until the command finishes
while [ -e /proc/$PID ]
do
    # Get the CPU usage and elapsed time
    CPU=$(ps -p $PID -o %cpu | tail -n 1)     # Use the "ps" command to get the CPU usage percentage of the process with the given PID
    ELAPSED=$(ps -p $PID -o etime | tail -n 1) # Use the "ps" command to get the elapsed time (in the format "DD-HH:MM:SS") of the process with the given PID

    # Get the memory usage
    MEM=$(ps -p $PID -o rss | tail -n 1)       # Use the "ps" command to get the resident set size (RSS) of the process with the given PID

    # Display the information
    truncate -s 0 info
    echo "CPU usage: $CPU" >> info      # Print the CPU usage percentage
    echo "Elapsed time: $ELAPSED" >> info # Print the elapsed time
    echo "Memory usage: $MEM" >> info   # Print the memory usage

    # Wait for a second before checking again
    # sleep 0.1      # Pause the script for 1 second before checking again
done | dialog --begin 7 5 --title "Log" --no-shadow --tailboxbg log 25 65 \
        --and-widget \
        --begin 7 75 --no-shadow --title "Information" --tailboxbg info 12 65 \
        --and-widget \
        --begin 20 75 --msgbox "Click [CTRL+C] (for definitive exit) or \"Accept\" when program finished\n\nwarning: If you click \"Accept\" and the program is not finished, you will encounter an empty box, just ctrl+c if you want to definitively exit without the program finishing" 12 65

dialog --clear --title "Result" --no-shadow --msgbox "Program finished successfully." 10 65

echo ""
rm log
rm info
