# Server Performance Stats

A simple Bash script that prints a snapshot of system resource usage on Linux.

## What it shows
- Total CPU utilization (sampled over 1 second)
- Memory usage (total / used / free)
- Disk usage for the root filesystem (/)
- Top 5 processes by CPU usage
- Top 5 processes by memory usage
- Timestamp of the last update

## Requirements
- Linux system with `/proc`
- `bash`
- Core utilities: `awk`, `grep`, `df`, `free`, `ps`, `date` (GNU coreutils / procps)

## Usage
```bash
./server-stats.sh
```

If the script is not executable yet:
```bash
chmod +x server-stats.sh
```

## Notes
- CPU usage is computed from two samples taken 1 second apart.
- Disk statistics are reported for the root filesystem only (`/`).
- Process lists use `ps auxc` (commands are shown without full arguments).

## Example Output
```
============================================================
 SYSTEM RESOURCE SUMMARY
============================================================

CPU
------------------------------------------------------------
 Total CPU usage:        12.3 %

MEMORY
------------------------------------------------------------
 Total:                31.3 GB
 Used:                 11.2 GB   (35.9 %)
 Free:                 20.1 GB   (64.1 %)

DISK (/)
------------------------------------------------------------
 Total:                512 GB
 Used:                 141 GB   (27.5 %)
 Free:                 371 GB   (72.5 %)

TOP PROCESSES BY CPU
------------------------------------------------------------
 PID     USER        CPU %     MEM %     COMMAND
 -----   ----------  --------  --------  -------------------
 1234    root        22.0      0.4       java
 ...

TOP PROCESSES BY MEMORY
------------------------------------------------------------
 PID     USER        MEM %     CPU %     COMMAND
 -----   ----------  --------  --------  -------------------
 5678    mysql       10.5      1.2       mysqld
 ...

============================================================
 Last update: 2026-02-10 14:22:31
============================================================
```
