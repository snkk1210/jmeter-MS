## What is this ?

JMeter クラスタ環境を AWS にデプロイする Terraform コードです。  

## Usage
### 1. 環境変数

- 環境変数に AWS のアクセスキーを設定
```
export TF_VAR_jmeter_aws_access_key=xxxxxxxxxxxxxxxxxxxxxx
export TF_VAR_jmeter_aws_secret_key=xxxxxxxxxxxxxxxxxxxxxx
```

### 2. キーペア設置

- SSH 公開鍵認証用のキーペアを配置
```
ssh-keygen -t rsa -b 2048 -f ./modules/ec2/secret_key/jmeter.key
mv ./modules/ec2/secret_key/jmeter.key.pub ./modules/ec2/public_key/jmeter.pub
chmod 700 ./modules/ec2/secret_key/jmeter.key
```

### 3. tf ファイル作成

- 雛形ファイルを元に .tf ファイルを作成
```
cp -p ./ec2.tf.example ./ec2.tf
cp -p ./network_ap-northeast-1.tf.example ./network_ap-northeast-1.tf
cp -p ./provider.tf.example ./provider.tf
cp -p ./terraform.tfvars.example ./terraform.tfvars
```

### 4. プロビジョニング設定

- Provisioning 用のフラグを立てる
```
vi ./ec2.tf
==========================
enable_c_provision = true
enable_w_provision = true
==========================
```

- SSH 接続元の IP Cidr に書き換える
```
vi ./ec2.tf
==========================
// Controller Server Connection IP
security_group_rules_controller = [
  "xxx.xxx.xxx.xxx/32",
]
// Worker Server Connection IP
security_group_rules_worker = [
  "xxx.xxx.xxx.xxx/32",
]
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

### 5. apply

```
terraform init
terraform apply
```