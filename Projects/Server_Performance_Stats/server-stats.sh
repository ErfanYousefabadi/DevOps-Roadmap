#!/bin/bash

cat <<EOF
============================================================
 SYSTEM RESOURCE SUMMARY
============================================================

EOF
echo "CPU"
echo ------------------------------------------------------------
echo -n " Total CPU usage:        "
top -bn 1 | grep '%Cpu' | cut -d ',' -f 4 | awk '{print 100 - $1 " %"}'
echo

echo MEMORY
echo ------------------------------------------------------------
echo -n " Total:                "
free | grep Mem: | awk '{printf "%.1f GB\n", $2 * 1024/1e9}'
echo -n " Used:                 "
free | grep Mem: | awk '{printf "%.1f GB   (%.1f %%)\n", $3*1024/1e9, $3/$2 *100}'
echo -n " Free:                 "
free | grep Mem: | awk '{printf "%.1f GB   (%.1f %%)\n\n", ($2-$3)*1024/1e9, ($2-$3)/$2 *100}'

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
top -bn1 -o +%CPU | head -n 12 | tail -n 5 | awk '{printf " %-8d%-12s%-10.1f%-10.1f%s\n", $1, $2, $9, $10, $12}'

cat << EOF

TOP PROCESSES BY MEMORY
------------------------------------------------------------
 PID     USER        MEM %     CPU %     COMMAND
 -----   ----------  --------  --------  -------------------
EOF
top -bn1 -o +%MEM | head -n 12 | tail -n 5 | awk '{printf " %-8d%-12s%-10.1f%-10.1f%s\n", $1, $2, $10, $9, $12}'

echo
echo ============================================================
echo -n " Last update: "
date "+%Y-%m-%d %H:%M:%S" 
echo ============================================================
