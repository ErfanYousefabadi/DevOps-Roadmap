#!/usr/bin/env bash

cat <<EOF
============================================================
 SYSTEM RESOURCE SUMMARY
============================================================

EOF
echo "CPU"
echo ------------------------------------------------------------
echo -n " Total CPU usage:        "
awk '{u=$2+$4; t=$2+$4+$5; if (NR==1){u1=u; t1=t;} else printf "%.1f %%\n", ($2+$4-u1)*100/(t-t1); }' \
<(grep 'cpu ' /proc/stat) <(sleep 1;grep 'cpu ' /proc/stat)
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

PS_OUT_CPU=$(ps auxc --sort=-pcpu)
PS_OUT_MEM=$(ps auxc --sort=-pmem)
CPU1=$(echo "$PS_OUT_CPU" | head -n2 | tail -n1 | awk '{print $3}')
MEM1=$(echo "$PS_OUT_MEM" | head -n2 | tail -n1 | awk '{print $4}')

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
