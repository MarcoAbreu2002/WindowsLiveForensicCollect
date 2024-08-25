# WindowsLiveForensicCollect

## Overview

**WindowsLiveForensicCollect** is a PowerShell script designed for live forensic data collection on Windows systems. This tool is intended for use by incident responders and forensic analysts to gather critical volatile and non-volatile data from a running Windows machine. It helps in capturing the system's current state, including processes, network connections, system information, and more, without altering the system's state.

## Features

- **Live Forensic Data Collection**: Captures crucial forensic data from a live Windows environment.
- **Volatile Data Collection**: Gathers real-time data such as running processes, active network connections, and open files.
- **Non-Volatile Data Collection**: Extracts static data like installed software, user accounts, and system configurations.
- **PowerShell Script**: Leverages the power of PowerShell for seamless integration with Windows environments.
- **Customizable Output**: Allows users to specify output paths for collected data.

## Requirements

- **Operating System**: Windows 7 and above
- **PowerShell**: Version 5.0 or higher

## Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/MarcoAbreu2002/WindowsLiveForensicCollect.git
   
   cd WindowsLiveForensicCollect
   ```
## Usage 

```bash
./main.ps1
```

Specify the destination and choose the type of collection.
