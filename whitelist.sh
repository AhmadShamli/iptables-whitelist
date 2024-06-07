#!/bin/bash

# Specify the IP addresses you want to allow (IPv4)
ALLOWED_IPS=("192.168.1.100" "192.168.1.101")

# Specify the IP addresses you want to allow (IPv6)
ALLOWED_IPS_V6=("2001:db8::1" "2001:db8::2")

# Function to check if a package is installed
is_installed() {
    dpkg -l "$1" &> /dev/null
    return $?
}

# Flush existing rules for IPv4
iptables -F
iptables -X

# Flush existing rules for IPv6
ip6tables -F
ip6tables -X

# Default policy to drop all incoming traffic (IPv4)
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Default policy to drop all incoming traffic (IPv6)
ip6tables -P INPUT DROP
ip6tables -P FORWARD DROP
ip6tables -P OUTPUT ACCEPT

# Allow loopback interface (localhost) for IPv4
iptables -A INPUT -i lo -j ACCEPT

# Allow loopback interface (localhost) for IPv6
ip6tables -A INPUT -i lo -j ACCEPT

# Allow established and related incoming connections (IPv4)
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow established and related incoming connections (IPv6)
ip6tables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow incoming traffic from specific IP addresses (IPv4)
for ip in "${ALLOWED_IPS[@]}"
do
    iptables -A INPUT -s "$ip" -j ACCEPT
done

# Allow incoming traffic from specific IP addresses (IPv6)
for ip in "${ALLOWED_IPS_V6[@]}"
do
    ip6tables -A INPUT -s "$ip" -j ACCEPT
done

# Save the rules for IPv4
iptables-save > /etc/iptables/rules.v4

# Save the rules for IPv6
ip6tables-save > /etc/iptables/rules.v6

# Check if iptables-persistent is installed, if not install it
if ! is_installed iptables-persistent; then
    apt-get update
    apt-get install -y iptables-persistent
fi

# Save the current rules
netfilter-persistent save

echo "Firewall rules applied. All inbound traffic is blocked except from the specified IPs."
