#!/bin/bash

echo "============== SERVER PERFORMANCE STATS =============="

# 1. CPU Usage
echo "\n--- CPU Usage ---"
top -bn1 | grep "Cpu(s)" | awk '{print "CPU Usage: " 100 - $8 "%"}'
# top -bn1: live list of system processes and stats, batch, once and exit
# grep "Cpu(s)": filters output to only show the line about CPU usage.
# awk '{print "CPU Usage: " 100 - $8 "%"}': prints CPU Usage of id (idle), subtracting it from 100 to get the actual usage.

# 2. Memory Usage
echo "\n--- Memory Usage ---"
free -h
echo ""
free | awk '/Mem:/ {
  used=$3; total=$2; percent=($3/$2)*100;
  printf("Used: %dMB / %dMB (%.2f%%)\n", used/1024, total/1024, percent)
}'
# first we show the -h (human readable) free command output
# then we parse the raw free version and use awk to calculate the $2: total memory and $3: used memory
# converting used and total from KB to MB with the /1024 operation

# 3. Disk Usage
echo "\n--- Disk Usage ---"
df -h --total | grep total
# disk free command: shows usage -h human readable, --total to add the row total
# grep to get the total row
df --total | grep total | awk '{used=$3; total=$2; percent=$5; printf("Used: %s / %s (%s)\n", used, total, percent)}'
# disk free raw, added total row, get with grep and parse with awk

# 4. Top 5 Processes by CPU
echo -e "\n--- Top 5 Processes by CPU ---"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
# process status command, -e all processes, -o format output (process id, command name, cpu usage percentage)
# --sort descending(-) by cpu usage
# head -n 6 show top 5 processes and header (6 rows)

# 5. Top 5 Processes by Memory
echo -e "\n--- Top 5 Processes by Memory ---"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6
# process status command, -e all processes, -o format output (process id, command name, memory usage percentage)
# --sort descending(-) by memory usage
# head -n 6 show top 5 processes and header (6 rows)

echo -e "\n=============================================="
