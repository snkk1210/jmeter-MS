## 概要

Master/Slave形式のjmeter環境をデプロイするplaybookです。

## 動作環境

CentOS7

## 使い方
1. git clone
```
git clone https://github.com/keisukesanuki/jmeter.git
```
2. 作業ディレクトリに移動
```
cd jmeter-MS
```
3. プロビジョニング対象を定義
```
vi hosts
```
⇒プロビジョニング対象のIPアドレスをそれぞれ記述する＊複数記述可  

```
[master] 
xxx.xxx.xxx.xxx ⇒ Masterノード  
[slave]  
xxx.xxx.xxx.xxx ⇒ Slaveノード
```


4. 実行ユーザを定義
```
vi target.yml
```
⇒下記項目に実行ユーザを記述

```
remote_user:  xxxxxx
```
5. VNC接続用のパスワードを定義

```
vi roles/tigervnc/files/vncpasswd.sh
```
⇒下記項目にVNC接続用のパスワードを定義

```
passwd=xxxxxx
```

6. playbookの実行
```
ansible-playbook operation.yml --ask-pass
```

or

```
ansible-playbook operation.yml --private-key=xxxxxxx
```
