## What is this ?

JMeter クラスター環境を AWS にデプロイする Terraform コードです。  

## Usage
### 1. キーペア作成

- SSH 認証用のキーペアを作成
```
ssh-keygen -t rsa -b 2048 -f ./modules/ec2/key/jmeter.key
chmod 700 ./modules/ec2/key/jmeter.key
```

### 2. パラメータ調整

- 雛形ファイルを元に tfvars ファイルを作成
```
cp -p ./terraform.tfvars.example ./terraform.tfvars
```

- SSH 接続元の IP Cidr に書き換える
```
vi ./terraform.tfvars
==========================
// Controller Server Connection IP
security_group_rules_controller = ["xx.xx.xx.xx/32"]
// Worker Server Connection IP
security_group_rules_worker     = ["xx.xx.xx.xx/32"]
==========================
```

- AMI に応じた接続用のユーザを定義 ( ex. ec2-user or centos )
```
cp -p ./../../target.yml.example ./../../target.yml
vi ./../../target.yml
==========================
remote_user: xxxxxx
==========================
```

- JMeter のパラメータを定義 ( README を参照してください )
```
cp -p ./../../group_vars/all.yml.example ./../../group_vars/all.yml
vi ./../../group_vars/all.yml
==========================
---
heapm_size: 256m
vnc_passwd: vncserver
remote_hosts: 192.168.33.10,192.168.33.11
#flanker_branch: release/0.0.7
==========================
```

### 3. デプロイ

```
terraform init
terraform apply
```