#!/bin/bash

# Check if domain argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

# Use the first argument as the domain name
domain=$1

# Define colors for output
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RESET="\033[0m"

# Define directories and log files with timestamps
timestamp=$(date +"%Y%m%d_%H%M%S")
base_dir="$domain"
info_path="$base_dir/info"
subdomain_path="$base_dir/subdomains"
screenshot_path="$base_dir/screenshots"
log_file="$base_dir/script_log_$timestamp.txt"

# Create directories if they don't exist
for path in "$info_path" "$subdomain_path" "$screenshot_path"; do
    if [ ! -d "$path" ]; then
        mkdir -p "$path"
        echo -e "${GREEN}Created directory: $path${RESET}" | tee -a "$log_file"
    fi
done

# Function to check and log the success or failure of commands with retry logic
run_command() {
    local cmd="$1"
    local log_file="$2"
    local retries=3
    local count=0

    echo -e "${RED} [+] Running: $cmd ... ${RESET}" | tee -a "$log_file"
    until $cmd >> "$log_file" 2>&1; do
        count=$((count+1))
        if [ $count -ge $retries ]; then
            echo -e "${RED} [!] Failed after $retries attempts: Check $log_file for details${RESET}" | tee -a "$log_file"
            return 1
        fi
        echo -e "${YELLOW} [*] Retry $count/${retries}...${RESET}" | tee -a "$log_file"
        sleep 5
    done
    echo -e "${GREEN} [+] Success: Output saved to $log_file${RESET}" | tee -a "$log_file"
}

# Run commands and save outputs
run_command "whois $domain" "$info_path/whois_$timestamp.txt"
run_command "subfinder -d $domain" "$subdomain_path/found_$timestamp.txt"
run_command "assetfinder $domain | grep $domain" "$subdomain_path/found_$timestamp.txt"

# Ensure there are no duplicate entries
sort -u "$subdomain_path/found_$timestamp.txt" -o "$subdomain_path/found_$timestamp.txt"

# Check for alive domains and save to a file
echo -e "${RED} [+] Checking what's alive ... ${RESET}" | tee -a "$log_file"
grep "$domain" "$subdomain_path/found_$timestamp.txt" | sort -u | httprobe -prefer-https | grep https | sed 's/https\?:\/\///' | tee "$subdomain_path/alive_$timestamp.txt" | tee -a "$log_file"

# Take screenshots of alive domains
echo -e "${RED} [+] Taking screenshots ... ${RESET}" | tee -a "$log_file"
gowitness file -f "$subdomain_path/alive_$timestamp.txt" -P "$screenshot_path/" --no-http

# Cleanup intermediate files if necessary
# Uncomment the following lines if you want to delete intermediate files after completion
# rm "$subdomain_path/found_$timestamp.txt"
# rm "$subdomain_path/alive_$timestamp.txt"

echo -e "${GREEN} [*] Script completed successfully.${RESET}" | tee -a "$log_file"
