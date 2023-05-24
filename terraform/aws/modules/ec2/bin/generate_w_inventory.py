#!/usr/bin/env python3

import sys

# Get the public IP of the EC2 instance
public_ip = sys.argv[1]

# Get the hostname of the EC2 instance
hostname = sys.argv[2]

# inventory file path
inventory_file = "ansible/hosts-w-" + public_ip

# Add IP address to inventory file
with open(inventory_file, "w") as f:
    f.write("[worker]\n")
    f.write(hostname + " ansible_host=" + public_ip)
    f.write("\n")

print("Inventory file generated successfully.")