#!/usr/bin/python3

import gspread
import json
import csv
import sys
import itertools

# シークレットキーを絶対パスで指定
SECRETJSON = "/usr/local/jmeter/bin/sacred-drive.json"
# スプレッドシートキーを定義
SPREADSHEET_KEY = '1hx8vE6N6EK5jGnknFPVv-_ejrwhhM-ywAnwpxowvDaQ'

############################################################################
## 関数

# 数字と文字コンバーター
def num2alpha(num):
    if num<=26:
        return chr(64+num)
    elif num%26==0:
        return num2alpha(num//26-1)+chr(90)
    else:
        return num2alpha(num//26)+chr(64+num%26)

#############################################################################
## 認証

# お約束
from oauth2client.service_account import ServiceAccountCredentials
scope = ['https://spreadsheets.google.com/feeds','https://www.googleapis.com/auth/drive']

# ダウンロードしたjsonファイルを定義
credentials = ServiceAccountCredentials.from_json_keyfile_name(SECRETJSON, scope)

# Google APIにログイン
gc = gspread.authorize(credentials)

# スプレッドシートのシート1を開く
worksheet = gc.open_by_key(SPREADSHEET_KEY).sheet1


##############################################################################
## 処理

# コマンドライン引数を取得
args = sys.argv
csvfile = args[1]
addurl = args[2]
addthread = args[3]
addrampup = args[4]
addloop = args[5]
addnode = args[6]
addsumthread = args[7]
addstarttime = args[8]
addendtime = args[9]

# CSVファイルの内容を配列に代入
with open(csvfile) as fp:
    results_list_ex = list(csv.reader(fp))

# 2次元配列を1次元配列に変換
results_list = list(itertools.chain.from_iterable(results_list_ex))

# 配列の最後に第二引数を追加
results_list.append(addurl)

# 配列の最初に第九引数を追加
results_list.insert(0, addendtime)

# 配列の最初に第八引数を追加
results_list.insert(0, addstarttime)

# 配列の最初に第七引数を追加
results_list.insert(0, addsumthread)

# 配列の最初に第六引数を追加
results_list.insert(0, addnode)

# 配列の最初に第五引数を追加
results_list.insert(0, addloop)

# 配列の最初に第四引数を追加
results_list.insert(0, addrampup)

# 配列の最初に第三引数を追加
results_list.insert(0, addthread)

# カウント変数初期化
COUNT_NUM = 1
# 空白行探索
while str(len(worksheet.cell(COUNT_NUM, 1).value)) != "0":
        COUNT_NUM += 1

# 編集する範囲を指定
cell_list = worksheet.range('A'+str(COUNT_NUM)+':'+num2alpha(len(results_list))+str(COUNT_NUM))
#cell_list = worksheet.range('D'+str(COUNT_NUM)+':'+'P'+str(COUNT_NUM))

# cell_listにresults_listの配列を代入
for i,cell in enumerate(cell_list):
    cell.value = results_list[i]

# 結果の保存
worksheet.update_cells(cell_list)
