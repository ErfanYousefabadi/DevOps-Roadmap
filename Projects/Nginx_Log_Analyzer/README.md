# Nginx Log Analyzer

A small Bash script that summarizes a standard Nginx access log (combined format) into the most common IPs, paths, status codes, and user agents.

## Requirements

- Bash
- Common Unix tools: `awk`, `cut`, `sort`, `uniq`, `head`

## Usage

```bash
./nginx-log-analyzer /path/to/access.log
```

## Expected Log Format

The script assumes the **Nginx combined access log** format. Example shape:

```
$remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent \
"$http_referer" "$http_user_agent"
```

## Output

The report includes:

1. Top 5 client IPs by request count
2. Top 5 requested paths
3. Top 5 response status codes
4. Top 5 user agents

## Notes

- If the log path is missing, unreadable, a directory, or empty, the script exits with a clear error message.
- If required tools are missing, the script will report each missing tool and exit.

