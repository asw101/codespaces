# Debug Utilities

This directory contains utilities for debugging GitHub Actions workflows and other CI/CD issues.

## Prerequisites

- [GitHub CLI (`gh`)](https://cli.github.com/) - Already installed in the devcontainer
- GitHub authentication configured (`gh auth login`)

## Available Commands

Run `just` to see all available recipes and their descriptions:

```bash
cd debug
just
```

## Quick Start

### Get Logs from the Latest Workflow Run

```bash
cd debug
just get-latest-logs
```

This will save the logs to `latest-run.log`.

### Get Logs from the Latest Failed Run

```bash
just get-failed-logs
```

This will find the most recent failed workflow run and save its logs to `failed-run.log`.

## Usage Examples

### Example 1: Debug the Latest Failure

```bash
cd debug

# Get logs from the latest failed run
just get-failed-logs

# Review the logs
cat failed-run.log
```

### Example 2: Check Recent Runs

```bash
cd debug

# List the last 20 runs
just list-runs 20

# Get detailed status of the latest run
just status-latest
```

### Example 3: Debug a Specific Run

```bash
cd debug

# List runs to find the ID you want
just list-runs

# Get logs for a specific run (e.g., run ID 12345678)
just get-logs 12345678 my-debug.log
```

### Example 4: Real-time Monitoring

```bash
cd debug

# Watch workflows in real-time
just watch

# In another terminal, if a run fails:
just get-latest-logs
```

### Example 5: Custom Output Location

```bash
cd debug

# Save logs to a custom location
just get-latest-logs output="../logs/workflow-$(date +%Y%m%d-%H%M%S).log"
```

## Workflow

A typical debugging workflow:

1. **Check what failed:**
   ```bash
   just list-runs
   ```

2. **Get the logs:**
   ```bash
   just get-failed-logs
   ```

3. **Review and analyze the failure:**
   ```bash
   cat failed-run.log
   # Or use your preferred AI tool to analyze the logs
   ```

4. **Make fixes to your code**

5. **Re-run the workflow:**
   ```bash
   just rerun-failed
   ```

6. **Monitor the re-run:**
   ```bash
   just watch
   ```

## Tips

- Run `just` to see all available commands
- Use `just list-runs` first to see the status of recent runs
- The `get-failed-logs` recipe searches the last 50 runs for failures
- Log files are saved in the current directory by default
- You can specify custom output paths for any log-fetching recipe
- Analyze log files with your preferred AI tool for debugging insights
