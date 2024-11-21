#Comprehensive script that identifies installed Redis and Memcached components using package detection, DNS records, or running processes.
#It displays the identified components along with their service status and critical configuration parameters.
#The script also allows saving the report with the hostname and timestamp.



#!/bin/bash

# Function to fetch Redis and Memcached packages
check_installed_packages() {
    echo "Checking for Redis and Memcached packages..."
    for package in redis-server memcached; do
        if dpkg -l | grep -q "$package"; then
            status=$(systemctl is-active "$package" 2>/dev/null || echo "not active")
            echo "$package: $status"
        else
            echo "$package: Not installed"
        fi
    done
}

# Function to identify Redis and Memcached running processes
check_running_processes() {
    echo "Checking running processes for Redis and Memcached..."
    ps aux | grep -E "redis|memcached" | grep -v grep | awk '{print $11}' | sort | uniq | while read -r process; do
        echo "$process: Running"
    done
}

# Function to check DNS records
check_dns_records() {
    echo "Checking DNS records for Redis and Memcached..."
    for service in redis memcached; do
        if host "$service" >/dev/null 2>&1; then
            echo "$service DNS entry exists"
        else
            echo "$service DNS entry not found"
        fi
    done
}

# Function to fetch critical configuration parameters
fetch_critical_configs() {
    echo "Fetching critical configuration parameters..."
    if systemctl is-active redis-server &>/dev/null; then
        redis_conf=$(redis-cli CONFIG GET maxmemory | tail -1)
        echo "Redis maxmemory: ${redis_conf:-Not configured}"
    else
        echo "Redis is not running"
    fi

    if systemctl is-active memcached &>/dev/null; then
        memcached_conf=$(ps aux | grep memcached | grep -v grep | awk '{for(i=1;i<=NF;i++) if($i ~ "-m") print $(i+1)}')
        echo "Memcached maxmemory: ${memcached_conf:-Not configured}"
    else
        echo "Memcached is not running"
    fi
}

# Function to save the report
save_report() {
    filename="redis_memcached_check_$(hostname)_$(date '+%Y%m%d_%H%M%S').txt"
    echo "Saving the report as $filename..."
    echo "$1" > "$filename"
    echo "Report saved successfully!"
}

# Main script
echo "Redis and Memcached Component Identification Script"
echo "---------------------------------------------------"

report=""

# Installed Packages Check
report+="\nInstalled Packages:\n"
installed_packages=$(check_installed_packages)
report+="$installed_packages\n"

# Running Processes Check
report+="\nRunning Processes:\n"
running_processes=$(check_running_processes)
report+="$running_processes\n"

# DNS Records Check
report+="\nDNS Records:\n"
dns_records=$(check_dns_records)
report+="$dns_records\n"

# Critical Configuration Parameters
report+="\nCritical Configuration Parameters:\n"
critical_configs=$(fetch_critical_configs)
report+="$critical_configs\n"

# Display report
echo -e "$report"

# Option to save report
read -p "Do you want to save this report to a file? (yes/no): " save_choice
if [[ "$save_choice" == "yes" ]]; then
    save_report "$report"
fi

echo "Script execution completed."
