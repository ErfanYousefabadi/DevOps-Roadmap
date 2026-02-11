# Log Archive Tool

A minimal Bash CLI utility that archives a log directory into a timestamped `.tar.gz` file.

The tool is designed to be simple, predictable, and safe to use in scripts or manually from the command line.

---

## Features

- Simple and explicit CLI interface
- Supports `-o/--output` for custom archive locations
- Optional verbose mode (`-v/--verbose`) to show `tar` output
- Automatically creates the output directory if it does not exist
- Generates timestamped archive filenames to avoid overwrites
- Clear error messages and built-in `--help`

---

## Requirements

- Bash (POSIX-compatible environment)
- `tar`

---

## Usage

```bash
log-archive [OPTIONS] LOG_DIR
```

### Arguments

- `LOG_DIR`  
  Path to the directory containing logs to archive.

### Options

- `-o, --output DIR`  
  Directory where the archive will be written  
  *(default: `./archives`)*

- `-v, --verbose`  
  Enable verbose `tar` output

- `-h, --help`  
  Show help and exit

---

## Examples

Archive `/var/log` into the default `./archives` directory:
```bash
log-archive /var/log
```

Specify a custom output directory:
```bash
log-archive -o ./archives /var/log
```

Enable verbose output:
```bash
log-archive --verbose /var/log
```

---

## Output Format

Archives are created using the following naming scheme:

```text
logs_archive_YYYYMMDD_HHMMSS.tar.gz
```

Example:
```text
logs_archive_20260212_143055.tar.gz
```

This guarantees uniqueness and makes it easy to identify when an archive was created.

---

## Installation

### Run Locally

From the project directory:
```bash
./log-archive [OPTIONS] LOG_DIR
```

Ensure the script is executable:
```bash
chmod +x log-archive
```

### Install System-Wide

To use the command from anywhere, copy it into a directory in your `$PATH` (commonly `/usr/local/bin`):

```bash
sudo cp log-archive /usr/local/bin/log-archive
sudo chmod +x /usr/local/bin/log-archive
```

Verify installation:
```bash
log-archive --help
```

---

## Notes

- Archiving system directories such as `/var/log` may require elevated permissions:
  ```bash
  sudo log-archive /var/log
  ```
- The tool does not modify or delete any log files—it only reads and archives them.
- Designed for simplicity; suitable for cron jobs, backups, or quick manual snapshots.
