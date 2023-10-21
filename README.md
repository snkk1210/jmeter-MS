## ・What is this ?

JMeter クラスタ環境をプロビジョニングする Ansible Playbook です。  
対応するクラウドリソースをデプロイする Terraform HCL も併せて管理しています。  
※ HCL 詳細は ./terraform/ 配下の README.md を参照下さい。  

## ・Requirements

### Target
- CentOS7
- AlmaLinux8
- AlmaLinux9
- RockyLinux9

## ・Usage
### 1. リポジトリを clone
```
git clone https://github.com/snkk1210/jmeter-MS.git
cd jmeter-MS
```

### 2. プロビジョニング対象を定義
```
cp -p hosts.example hosts
vi hosts
```
⇒ プロビジョニング対象の IP アドレス をそれぞれ記述して下さい。   
※ 複数記述可  

```
[controller] 
jmeter-controller ansible_host=xxx.xxx.xxx.xxx ⇐ controller ノード  
[worker]  
jmeter-worker1 ansible_host=xxx.xxx.xxx.xxx ⇐ worker ノード
jmeter-worker2 ansible_host=xxx.xxx.xxx.xxx ⇐ worker ノード
```

### 3. 接続ユーザを定義
```
cp -p target.yml.example target.yml
vi target.yml
```
⇒ 下記項目にプロビジョニング対象への SSH 接続ユーザを定義

```
remote_user: xxxxxx
```
### 4. 各種変数を定義

```
cp -p group_vars/all.yml.example group_vars/all.yml
vi group_vars/all.yml
```

- HEAPメモリ のサイズを定義  
※ 定義しなければ 256M が設定されます。
```
heapm_size: xxxm
```

- VNC 接続のパスワードを定義 ( 6 文字以上 )  
※ 定義しなければ「vncserver」が設定されます。
```
vnc_passwd: string_6
```

- Controller に紐づける Worker の IP アドレスをカンマ ( , ) 区切りで定義  
※ 後述の WEB コンパネでも操作可能なので定義しなくても OK
```
remote_hosts: 192.168.33.xx,192.168.33.xx
```

- WEB コンパネアプリのブランチを指定  
※ 定義がなければ、最新版が導入されます。
```
flanker_branch: release/0.0.7
```

### 5. Playbook の実行

- パスワード
```
ansible-playbook -i hosts target.yml --ask-pass
```

- 秘密鍵
```
ansible-playbook -i hosts target.yml --private-key=xxxxxxx
```

## ・WEB コンパネ

WEB ベースで JMeter を一括操作できるコントロールパネルを用意しています。  

※ 詳細は下記リポジトリの README を参照下さい。  
https://github.com/snkk1210/flanker


## ・プロビジョニング後の対応
※ 先の「WEB コンパネ」で JMeter を操作するのであれば、本項は無視ください。

### 1. Controller と Worker の紐づけ

```
vi /usr/local/jmeter/bin/jmeter.properties
```

⇒ 下記項目に使用する worker サーバの IP を記述する  
※ 複数指定可 ( , で区切る )

```
remote_hosts=xxx.xxx.xxx.xxx,xxx.xxx.xxx.xxx,xxx.xxx.xxx.xxx
```

### 2. Controller サーバの JMeter 起動スクリプト調整

```
vi /usr/local/jmeter/bin/start-controller_cui.sh
```
⇒ 下記に使用するシナリオファイルを絶対パスで定義

```
FILE_JMX=
```

### 3. JMeter の起動（負荷試験開始）

```
/usr/local/jmeter/bin/start-controller_cui.sh
```
⇒ 試験結果レポートは Apache のドキュメントルート配下に生成されます。  
※ Controller サーバにブラウザで接続して確認することが可能です。  

## ・トラシュー

### vncserver が立ち上がらない時

```
rm /tmp/.X11-unix/*
systemctl restart vncserver@:1.service
```

## ・Version

release/0.0.5