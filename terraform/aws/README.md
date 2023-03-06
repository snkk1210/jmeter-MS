## What is this ?

JMeter クラスタ環境デプロイ用の AWS リソースを作成する Terraform コードです。  

## Usage
### 1. 環境変数

```
export TF_VAR_jmeter_aws_access_key=
export TF_VAR_jmeter_aws_secret_key=
```

### 2. JMeter 公開鍵設置

SSH 公開鍵認証用の公開鍵を下記ファイル名で配置
```
./modules/ec2/public_key/jmeter.pub
```

### 2. .tf ファイル

雛形ファイルを元に .tf ファイルを作成
```
cp -p ./ec2.tf.example ./ec2.tf
cp -p ./network_ap-northeast-1.tf.example ./network_ap-northeast-1.tf
cp -p ./provider.tf.example ./provider.tf
cp -p ./terraform.tfvars.example ./terraform.tfvars
```

### 3. apply

```
terraform init
terraform apply
```