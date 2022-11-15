#!/bin/sh

DATE=$(date +"%Y%m%d")
OPTIME=$(date +"%Y%m%d-%H%M%S")
# 結果の出力先ディレクトリを指定
LOGDIR=/var/www/html/${DATE}
# JMXファイルを指定
FILE_JMX=/usr/local/jmeter/bin/templates/build-web-test-plan.jmx

# 日付ディレクトリの作成
mkdir -p ${LOGDIR}

# JMeter 実行
/usr/local/jmeter/bin/jmeter -Dsun.net.inetaddr.ttl=0 -n -t ${FILE_JMX} -j ${LOGDIR}/${OPTIME}.log -l ${LOGDIR}/${OPTIME}.jtl -e -o ${LOGDIR}/${OPTIME}/ -r

# CSVファイル 作成
cat ${LOGDIR}/${OPTIME}/statistics.json | jq  -r ". [] | [.transaction,.sampleCount,.errorCount,.errorPct,.meanResTime,.minResTime,.maxResTime,.pct1ResTime,.pct2ResTime,.pct3ResTime,.throughput,.receivedKBytesPerSec,.sentKBytesPerSec] | @csv" | grep "Total" > ${LOGDIR}/${OPTIME}/statistics.csv
