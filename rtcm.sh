#!/bin/bash

# # Start the command and capture its PID
$@ &> log &  # Execute the command passed as argument in the background
PID=$!       # Capture the PID of the command (i.e., the PID of the last background process)

# Loop until the command finishes
while [ -e /proc/$PID ]
do
    # Get the CPU usage and elapsed time
    CPU=$(ps -p $PID -o %cpu | tail -n 1)     # Use the "ps" command to get the CPU usage percentage of the process with the given PID
    ELAPSED=$(ps -p $PID -o etime | tail -n 1) # Use the "ps" command to get the elapsed time (in the format "DD-HH:MM:SS") of the process with the given PID

    # Get the memory usage
    MEM=$(ps -p $PID -o rss | tail -n 1)       # Use the "ps" command to get the resident set size (RSS) of the process with the given PID

    # Display the information
    echo "CPU usage: $CPU"      # Print the CPU usage percentage
    echo "Elapsed time: $ELAPSED" # Print the elapsed time
    echo "Memory usage: $MEM"   # Print the memory usage

    # Wait for a second before checking again
    sleep 1      # Pause the script for 1 second before checking again
done | dialog --begin 7 5  --no-shadow --title "Log" --tailboxbg log 25 130 \
              --and-widget \
              --begin 1 5 --no-shadow --title "Progress" --menu 5 130 0 && \

rm log