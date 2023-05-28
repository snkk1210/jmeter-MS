## What is this ?

JMeter クラスタ環境を AWS にデプロイする Terraform コードです。  

## Usage
### 1. 環境変数

- AWS のアクセスキーを定義
```
export TF_VAR_jmeter_aws_access_key=
export TF_VAR_jmeter_aws_secret_key=
```

### 2. JMeter キーペア設置

- SSH 公開鍵認証用の公開鍵を下記ファイル名で配置
```
./modules/ec2/public_key/jmeter.pub
```
- SSH 公開鍵認証用の秘密鍵を下記ファイル名で配置
```
./modules/ec2/secret_key/jmeter.key
```
※ 秘密鍵のパーミッションを調整
```
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

### 4. Ansible での JMeter プロビジョニング

- Provisioning 用のフラグを立てる
```
vi ./ec2.tf
==========================
enable_c_provision = true
enable_w_provision = true
==========================
```

- IAM に対応した接続用のユーザを定義 ( ec2-user / centos )
```
cp -p ./../../target.yml.example ./../../target.yml
vi ./../../target.yml
==========================
remote_user: xxxxxx
==========================
```

- JMeter 用のパラメータを定義 ( README を参照してください )
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