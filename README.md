# iptables-whitelist
A bash script that will block all inbound traffic except from specified IP addresses using iptables.
Replace the placeholder IP addresses with the ones you want to allow.


## Instructions to Use the Script
  Save the Script: Save the script to a file, e.g., whitelist.sh.
  
  Make the Script Executable: Run chmod +x whitelist.sh to make the script executable.
  
  Run the Script: Execute the script with sudo ./whitelist.sh to apply the rules.


## Explanation
  Flush existing rules: iptables -F and iptables -X flush all existing rules and custom chains.
  
  Default policy to drop: The default policy for INPUT and FORWARD chains is set to DROP, while OUTPUT is set to ACCEPT.
  
  Loopback interface: iptables -A INPUT -i lo -j ACCEPT allows traffic on the loopback interface.
  
  Established connections: iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT allows incoming traffic for established and related connections.
  
  Allow specific IPs: The script iterates over the allowed IPs and adds rules to accept traffic from these IPs.
  
  Save the rules: iptables-save > /etc/iptables/rules.v4 saves the rules to be persistent across reboots.


Make sure to run this script with root privileges (using sudo) to ensure the changes are applied correctly.
