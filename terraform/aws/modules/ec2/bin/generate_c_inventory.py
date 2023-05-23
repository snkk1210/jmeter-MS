#!/usr/bin/env python3

import sys

# inventory file path
inventory_file = "ansible/hosts"

# Get the public IP of the EC2 instance
public_ip = sys.argv[1]

# Add IP address to inventory file
with open(inventory_file, "w") as f:
    f.write("[controller]\n")
    f.write(public_ip)
    f.write("\n")

print("Inventory file generated successfully.")