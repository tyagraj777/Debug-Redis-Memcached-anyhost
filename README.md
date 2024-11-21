# Debug-Redis-Memcached-anyhost
This script ensures comprehensive monitoring and analysis of Redis and Memcached installations, helping system administrators maintain their environment effectively.


Features:

1. Package Check: Verifies if Redis and Memcached are installed.

2. Service Status: Displays service status (active, inactive, or not installed).

3. Process Check: Identifies running Redis and Memcached processes.

4. DNS Validation: Validates DNS records for Redis and Memcached services.

5. Critical Configurations: Fetches key parameters like maxmemory for Redis and Memcached.

6. Report Saving: Option to save the output as a file with the hostname and timestamp.


* Instructions:

a. Save the script as redis_memcached_check.sh.

b. Make it executable: chmod +x redis_memcached_check.sh.

c. Run the script: sudo ./redis_memcached_check.sh


