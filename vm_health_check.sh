#!/bin/bash

# Function to get CPU utilization as a percentage
get_cpu_utilization() {
    # Get the idle CPU percentage from top (average over 1 second)
    CPU_IDLE=$(top -bn2 | grep "Cpu(s)" | tail -n1 | awk '{print $8}')
    CPU_UTIL=$(echo "100 - $CPU_IDLE" | bc)
    # Remove decimal if present
    CPU_UTIL=${CPU_UTIL%.*}
    echo $CPU_UTIL
}

# Function to get Memory utilization as a percentage
get_mem_utilization() {
    # Get total and available memory from free command
    MEM_TOTAL=$(free | grep Mem | awk '{print $2}')
    MEM_USED=$(free | grep Mem | awk '{print $3}')
    MEM_UTIL=$(echo "$MEM_USED * 100 / $MEM_TOTAL" | bc)
    echo $MEM_UTIL
}

# Function to get Disk utilization as a percentage (root partition)
get_disk_utilization() {
    # Get disk utilization for root partition
    DISK_UTIL=$(df / | tail -1 | awk '{print $5}' | tr -d '%')
    echo $DISK_UTIL
}

CPU_UTIL=$(get_cpu_utilization)
MEM_UTIL=$(get_mem_utilization)
DISK_UTIL=$(get_disk_utilization)

echo "CPU Utilization: $CPU_UTIL%"
echo "Memory Utilization: $MEM_UTIL%"
echo "Disk Utilization (root): $DISK_UTIL%"

if [ "$CPU_UTIL" -lt 60 ] && [ "$MEM_UTIL" -lt 60 ] && [ "$DISK_UTIL" -lt 60 ]; then
    echo "VM Health Status: HEALTHY"
else
    echo "VM Health Status: NOT HEALTHY"
fi