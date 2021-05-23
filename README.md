## 概要

Master/Slave形式のjmeter環境をデプロイするplaybookです。

## 動作環境

CentOS7

## 使い方
### 1. リポジトリをclone
```
git clone https://github.com/keisukesanuki/jmeter.git
cd jmeter-MS
```

### 2. プロビジョニング対象を定義
```
vi hosts
```
⇒プロビジョニング対象のIPアドレスをそれぞれ記述する＊複数記述可  

```
[master] 
jmeter-master ansible_host=xxx.xxx.xxx.xxx ⇒ Masterノード  
[slave]  
jmeter-node1 ansible_host=xxx.xxx.xxx.xxx ⇒ Slaveノード
jmeter-node2 ansible_host=xxx.xxx.xxx.xxx ⇒ Slaveノード
```

### 3. 実行ユーザを定義
```
vi target.yml
```
⇒下記項目に実行ユーザを記述

```
remote_user:  xxxxxx
```
### 4. VNC接続用のパスワードを定義

```
vi roles/tigervnc/files/vncpasswd.sh
```
⇒下記項目にVNC接続用のパスワードを定義

```
passwd=xxxxxx
```

### 5. HEAPメモリのサイズを定義

```
cp -p group_vars/all.yml.example group_vars/all.yml
vi group_vars/all.yml
```
⇒下記項目にHEAPメモリのサイズを定義

```
heapm_size: 
```

### 6. playbookの実行

* パスワード
```
ansible-playbook -i hosts target.yml --ask-pass
```

* 秘密鍵

```
ansible-playbook -i hosts target.yml --private-key=xxxxxxx
```

## プロビジョニング後の対応

### 1. MaterとSlaveの紐づけ

```
vi /usr/local/jmeter/bin/jmeter.properties
```

⇒下記項目に使用するslaveサーバのIPを記述する
＊複数指定可(,で区切る)

```
remote_hosts=xxx.xxx.xxx.xxx,xxx.xxx.xxx.xxx,xxx.xxx.xxx.xxx
```

### 2.Materサーバのjmeter起動スクリプト調整

```
vi /usr/local/jmeter/bin/start-controller_cui.sh
```
⇒下記項目に使用するシナリオファイルを絶対パスで定義

```
FILE_JMX=
```

### 3.jmeterの起動（負荷試験開始）

```
/usr/local/jmeter/bin/start-controller_cui.sh
```

## トラシュー

### vncserverが立ち上がらない時

```
rm /tmp/.X11-unix/*
systemctl restart vncserver@:1.service
```

## おまけ

jmeterの結果をgoogleスプレッドシートに出力するpythonスクリプトを用意しています。  
＊jmeter起動スクリプトと併せて実行されます。


下記3点を事前に準備する必要があります。  
・Google Drive API/Google Sheets APIの有効化  
・秘密鍵(JSONデータ)のダウンロード  
・スプレッドシートの共有設定

諸々は下記からどうぞ！  
https://console.developers.google.com/


スクリプト内の下記2点は適宜環境に併せる必要があります。  
・「SECRETJSON」にGoogle APIの秘密鍵ファイルを指定してください。  
・「SPREADSHEET_KEY」に結果を出力するシートのキーを指定してください。  

```
vi /usr/local/bin/main.py
```

こちらのpythonスクリプトが必要なければ、jmeterの起動スクリプト内の下記項目をコメントアウトしてください。

```
/usr/local/bin/main.py ${LOGDIR}/${OPTIME}_th/statistics.csv
```