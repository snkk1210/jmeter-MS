#!/bin/sh

DATE=$(date +"%Y%m%d")
OPTIME=$(date +"%Y%m%d-%H%M%S")
#結果の出力先ディレクトリを指定
LOGDIR=/var/www/html/${DATE}
#JMXファイルを指定
FILE_JMX=/usr/local/jmeter/bin/templates/build-web-test-plan.jmx
#ホストのIPアドレスを定義
SELF_IPADDR=192.168.33.10
#SELF_IPADDR=`curl inet-ip.info`

# スレッド数
THREAD_NUM=`grep "ThreadGroup.num_threads" ${FILE_JMX} | sed -e "s/^.*<stringProp.*>\(.*\)<\/stringProp>.*$/\1/"`
# ランプアップ数
RAMPUP_NUM=`grep "ThreadGroup.ramp_time" ${FILE_JMX} | sed -e "s/^.*<stringProp.*>\(.*\)<\/stringProp>.*$/\1/"`
# ループ回数
LOOP_NUM=`grep "LoopController.loops" ${FILE_JMX} | sed -e "s/^.*<stringProp.*>\(.*\)<\/stringProp>.*$/\1/"`
# ノード数
NODE_NUM=`grep -E "^remote_hosts" /usr/local/jmeter/bin/jmeter.properties | tr -d "remote_hosts=" | awk -F ',' '{print NF}'`
# 総スレッド数
SUM_THREAD_NUM=`(expr ${THREAD_NUM} \* ${NODE_NUM})`


# 日付ディレクトリの作成
mkdir -p ${LOGDIR}

# jmeterの実行
/usr/local/jmeter/bin/jmeter -Dsun.net.inetaddr.ttl=0 -n -t ${FILE_JMX} -j ${LOGDIR}/${OPTIME}.log -l ${LOGDIR}/${OPTIME}.jtl -e -o ${LOGDIR}/${OPTIME}_th${JMETER_THREAD}${2}/ -r

# CSVファイルの作成
cat ${LOGDIR}/${OPTIME}_th${JMETER_THREAD}${2}/statistics.json | jq  -r ". [] | [.transaction,.sampleCount,.errorCount,.errorPct,.meanResTime,.minResTime,.maxResTime,.pct1ResTime,.pct2ResTime,.pct3ResTime,.throughput,.receivedKBytesPerSec,.sentKBytesPerSec] | @csv" | grep "Total" > ${LOGDIR}/${OPTIME}_th${JMETER_THREAD}${2}/statistics.csv


# 開始時刻
START_TIME=`grep -A 1 "Start Time" ${LOGDIR}/${OPTIME}_th${JMETER_THREAD}${2}/index.html | tail -n 1 | sed -e 's/<[^>]*>//g' | xargs printf "%-20s\n" | awk '{print $2}'`
# 終了時刻
END_TIME=`grep -A 1 "End Time" ${LOGDIR}/${OPTIME}_th${JMETER_THREAD}${2}/index.html | tail -n 1 | sed -e 's/<[^>]*>//g' | xargs printf "%-20s\n" | awk '{print $2}'`

# スプレッドシートに結果を出力
/usr/local/bin/main5.py ${LOGDIR}/${OPTIME}_th/statistics.csv http://${SELF_IPADDR}/${DATE}/${OPTIME}_th ${THREAD_NUM} ${RAMPUP_NUM} ${LOOP_NUM} ${NODE_NUM} ${SUM_THREAD_NUM} ${START_TIME} ${END_TIME}
