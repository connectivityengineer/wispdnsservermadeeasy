#!/bin/bash

# a simple script for installing bind configuring to use root hints and updating firewall 
# as i have been given to freely so i freely give

# Update and install necessary packages
sudo apt update && sudo apt install -y bind9 bind9utils ufw

# Predefined IP ranges
declare -a predefined_ranges=("10.0.0.0/8" "172.16.0.0/12" "192.168.0.0/16" "100.64.0.0/10")

# Get server's own subnet
server_subnet=$(ip route | awk '/src/ {print $1}')
predefined_ranges+=("$server_subnet")

# Inform the user of predefined IP ranges
echo "The following IP ranges will be automatically included:"
for range in "${predefined_ranges[@]}"; do
    echo " - $range"
done

echo "You can add additional IP ranges if needed."
echo "Enter 'done' when you are finished."

additional_ranges=()
while :; do
    read -rp "Enter IP range (or 'done'): " ip_range
    if [[ $ip_range == "done" ]]; then
        break
    fi
    additional_ranges+=("$ip_range")
done

# Configure BIND to use root hints
sudo bash -c 'echo "options {
    directory \"/var/cache/bind\";
    recursion yes;
    allow-recursion { any; };
    forwarders { };
    forward only;
    dnssec-validation auto;
    auth-nxdomain no;    # conform to RFC1035
    listen-on-v6 { any; };
};" > /etc/bind/named.conf.options'

# Restart BIND
sudo systemctl restart bind9

# Prompt user for custom SSH port
read -rp "Enter custom SSH port: " ssh_port
sudo sed -i "s/^#*Port .*/Port $ssh_port/" /etc/ssh/sshd_config

# Restart SSHD
sudo systemctl restart sshd

# Enable UFW and add rules
sudo ufw enable

# Allow custom SSH port in UFW
sudo ufw allow "$ssh_port"/tcp

# Add predefined and additional IP ranges to UFW for DNS
for range in "${predefined_ranges[@]}" "${additional_ranges[@]}"; do
    sudo ufw allow from "$range" to any port 53
done

# Final message
echo "Setup complete! Remember to login using the new SSH port: $ssh_port"

