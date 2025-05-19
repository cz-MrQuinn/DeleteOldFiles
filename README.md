# DeleteOldFiles

A simple PowerShell-based cleanup tool that automatically deletes old files from specified directories based on configurable rules.

## Features

- Reads cleanup rules from a JSON configuration file
- Supports filtering by file age and extension
- Deletes files recursively within specified directories
- Can be scheduled using Windows Task Scheduler

## Configuration

The configuration is stored in a JSON file named `DeleteOldFiles_config.json`. Each entry contains:

- `older_than_days`: Number of days a file must be older than to be deleted
- `filetype`: File extension filter (e.g., `pdf`, `jpg`, or `*` for all)
- `path`: Full path to the directory to clean

### Example:

```json
[
    {
        "older_than_days": 90,
        "filetype": "pdf",
        "path": "D:\\skener_E\\"
    },
    {
        "older_than_days": 90,
        "filetype": "*",
        "path": "D:\\skener_E\\scany\\"
    }
]
