#!/usr/bin/env python3

import sys

# インベントリファイルパス
inventory_file = "ansible/hosts"

# EC2 インスタンスのパブリック IP を取得
public_ip = sys.argv[1]

# インベントリファイルに IP アドレスを追加
with open(inventory_file, "w") as f:
    f.write("[controller]\n")
    f.write(public_ip)
    f.write("\n")

print("Inventory file generated successfully.")