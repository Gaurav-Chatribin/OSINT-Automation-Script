# Domain OSINT Information Automation Script

This script automates the process of gathering domain information, discovering subdomains, checking for live domains, and taking screenshots of these domains. It leverages various tools to perform these tasks and logs the results for further analysis.

## Features

- Retrieves WHOIS information for a given domain.
- Discovers subdomains using `subfinder` and `assetfinder`.
- Checks for live domains using `httprobe`.
- Takes screenshots of live domains using `gowitness`.
- Logs all activities and errors to a timestamped log file.

## Prerequisites

Ensure you have the following tools installed:

- `whois` (for domain WHOIS lookups)
- `subfinder` (for subdomain discovery)
- `assetfinder` (for asset discovery)
- `httprobe` (for probing live domains)
- `gowitness` (for taking screenshots of domains)

You can install these tools via their respective installation methods, typically found in their documentation or GitHub repositories.

## Installation

1. Clone this repository to your local machine:
   ```bash
   git clone https://github.com/Gaurav-Chatribin/OSINT-Automation-Script.git
   cd domain-info-screenshot-script

2. Make the script executable:
   ```bash
   chmod +x script.sh

## Usage
To use the script, run it with a domain name as an argument:
<pre>
<code class="language-bash">
  ./OSINT-script.sh example.com
</code>
</pre>
  
This will create directories for storing results, run the necessary commands to gather information and take screenshots, and save the outputs to timestamped files.

## Log Files
The script creates log files with a timestamp in the domain's base directory. These logs include details of all commands run and their outputs.

## Cleanup
The script does not delete intermediate files by default. Uncomment the cleanup lines in the script to automatically remove intermediate files after completion.

## Example Output
The script generates the following outputs:
- info/: Contains WHOIS information.
- subdomains/: Contains discovered subdomains and alive domains.
- screenshots/: Contains screenshots of live domains.
- script_log_<timestamp>.txt: A log file with details of the script's execution.

## Disclaimer
This script is intended for educational and authorized security testing purposes only. Misuse of this script could result in criminal charges. Use responsibly and only on domains that you own or have permission to test.
