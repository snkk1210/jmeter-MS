## 概要

JMeter クラスター環境をデプロイする Playbook です。

## 動作環境

- CentOS7
- AlmaLinux8

## 使い方
### 1. リポジトリを clone
```
git clone https://github.com/keisukesanuki/jmeter-MS.git
cd jmeter-MS
```

### 2. プロビジョニング対象を定義
```
cp -p hosts.example hosts
vi hosts
```
⇒ プロビジョニング対象の IP アドレス をそれぞれ記述する  
※ 複数記述可  

```
[controller] 
jmeter-controller ansible_host=xxx.xxx.xxx.xxx ⇒ controller ノード  
[worker]  
jmeter-worker1 ansible_host=xxx.xxx.xxx.xxx ⇒ worker ノード
jmeter-worker2 ansible_host=xxx.xxx.xxx.xxx ⇒ worker ノード
```

### 3. 実行ユーザを定義
```
cp -p target.yml.example target.yml
vi target.yml
```
⇒ 下記項目に実行ユーザを記述

```
remote_user:  xxxxxx
```
### 4. VNC 接続用のパスワードを定義

```
vi roles/tigervnc/files/vncpasswd.sh
```
⇒ 下記項目に VNC 接続用のパスワードを定義

```
passwd=xxxxxx
```

### 5. HEAP メモリ のサイズを定義

```
cp -p group_vars/all.yml.example group_vars/all.yml
vi group_vars/all.yml
```
⇒ 下記項目に HEAPメモリ のサイズを定義

```
heapm_size: 
```

### 6. Playbook の実行

* パスワード
```
ansible-playbook -i hosts target.yml --ask-pass
```

* 秘密鍵

```
ansible-playbook -i hosts target.yml --private-key=xxxxxxx
```

## プロビジョニング後の対応

### 1. Controller と Worker の紐づけ

```
vi /usr/local/jmeter/bin/jmeter.properties
```

⇒ 下記項目に使用する worker サーバの IP を記述する  
※ 複数指定可(,で区切る)

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

## WEB コンパネ

WEB ベースで JMeter を操作できるコントロールパネルを用意しています。  

※ 詳細は下記リポジトリの README を参照下さい。  
https://github.com/snkk1210/flanker

## トラシュー

### vncserver が立ち上がらない時

```
rm /tmp/.X11-unix/*
systemctl restart vncserver@:1.service
```

## おまけ

JMeter の結果を google スプレッドシート に出力する Python スクリプトを用意しています。  
※ JMeter 起動スクリプトと併せて実行されます。


下記3点を事前に準備する必要があります。  
・Google Drive API / Google Sheets API の有効化  
・秘密鍵( JSONデータ )のダウンロード  
・スプレッドシートの共有設定

諸々は下記からどうぞ！  
https://console.developers.google.com/


スクリプト内の下記2点は適宜環境に併せる必要があります。  
・ SECRETJSON に Google API の秘密鍵ファイルを指定してください。  
・ SPREADSHEET_KEY に結果を出力するシートのキーを指定してください。  

```
vi /usr/local/bin/main.py
```

JMeter 起動スクリプトの下記項目をコメントインしてください。

```
#/usr/local/bin/main.py ${LOGDIR}/${OPTIME}_th/statistics.csv
```