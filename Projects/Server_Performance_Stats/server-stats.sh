#!/usr/bin/env bash
#
# server-stats.sh
#
# Prints a snapshot of system resource usage, including:
#   - total CPU utilization (sampled over 1 second)
#   - memory usage (total / used / free)
#   - disk usage for the root filesystem (/)
#   - top processes by CPU and memory usage
#
# Data sources:
#   - /proc/stat for CPU usage
#   - free(1) for memory statistics
#   - df(1) for disk usage
#   - ps(1) for process information
#
# Usage:
#   ./server-stats.sh
#
# Requirements:
#   - Linux system with /proc
#   - awk, grep, df, free, ps, date (GNU coreutils / procps)
#
# Notes:
#   - CPU usage is calculated from two samples taken 1 second apart.
#   - Disk statistics are reported for the root filesystem only (/).

cat <<EOF
============================================================
 SYSTEM RESOURCE SUMMARY
============================================================

EOF

# Sample /proc/stat twice and compute usage from deltas
echo "CPU"
echo ------------------------------------------------------------
echo -n " Total CPU usage:        "
awk '{u=$2+$4; t=$2+$4+$5; if (NR==1){u1=u; t1=t;} else printf "%.1f %%\n", ($2+$4-u1)*100/(t-t1); }' \
<(grep 'cpu ' /proc/stat) <(sleep 1;grep 'cpu ' /proc/stat)
echo

# Report Memory statistics
echo MEMORY
echo ------------------------------------------------------------
echo -n " Total:                "
free | grep Mem: | awk '{printf "%.1f GB\n", $2 * 1024/1e9}'
echo -n " Used:                 "
free | grep Mem: | awk '{printf "%.1f GB   (%.1f %%)\n", $3*1024/1e9, $3/$2 *100}'
echo -n " Free:                 "
free | grep Mem: | awk '{printf "%.1f GB   (%.1f %%)\n\n", ($2-$3)*1024/1e9, ($2-$3)/$2 *100}'

# Report disk statistics for the root filesystem only
echo "DISK (/)"
echo ------------------------------------------------------------
echo -n " Total:                "
df -H | grep "/$" | awk '{print $2}' | cut -d 'G' -f 1 | awk '{printf "%d GB\n", $1}'
echo -n " Used:                 "
df -H | grep "/$" | awk '{print $3}' | cut -dG -f1 | awk '{printf "%d GB   ", $1}'
df -H | grep "/$" | awk '{print $5}' | cut -d% -f1 | awk '{printf "(%.1f %%)\n", $1}'
echo -n " Free:                 "
df -H | grep "/$" | awk '{print $4}' | cut -dG -f1 | awk '{printf "%d GB   ", $1}'
df -H | grep "/$" | awk '{print $5}' | cut -d% -f1 | awk '{printf "(%.1f %%)\n\n", 100-$1}'

cat << EOF
TOP PROCESSES BY CPU
------------------------------------------------------------
 PID     USER        CPU %     MEM %     COMMAND
 -----   ----------  --------  --------  -------------------
EOF

PS_OUT_CPU=$(ps auxc --sort=-pcpu)
PS_OUT_MEM=$(ps auxc --sort=-pmem)
# Extract the top process percentages to handle ps header alignment
CPU1=$(echo "$PS_OUT_CPU" | head -n2 | tail -n1 | awk '{print $3}')
MEM1=$(echo "$PS_OUT_MEM" | head -n2 | tail -n1 | awk '{print $4}')

# Adjust row selection if ps reports a 100% value
if [[ $CPU1 = 100 ]]; then
  echo "$PS_OUT_CPU" | head -n7 | tail -n5 | awk '{printf " %-8d%-12s%-10.1f%-10.1f%s\n", $2, $1, $3, $4, $11}'
else
  echo "$PS_OUT_CPU" | head -n6 | tail -n5 | awk '{printf " %-8d%-12s%-10.1f%-10.1f%s\n", $2, $1, $3, $4, $11}'
fi

cat << EOF

TOP PROCESSES BY MEMORY
------------------------------------------------------------
 PID     USER        MEM %     CPU %     COMMAND
 -----   ----------  --------  --------  -------------------
EOF

# Adjust row selection if ps reports a 100% value
if [[ $MEM1 = 100 ]]; then
  echo "$PS_OUT_MEM" | head -n7 | tail -n5 | awk '{printf " %-8d%-12s%-10.1f%-10.1f%s\n", $2, $1, $4, $3, $11}'
else
  echo "$PS_OUT_MEM" | head -n6 | tail -n5 | awk '{printf " %-8d%-12s%-10.1f%-10.1f%s\n", $2, $1, $4, $3, $11}'
fi

echo
echo ============================================================
echo -n " Last update: "
date "+%Y-%m-%d %H:%M:%S" 
echo ============================================================
