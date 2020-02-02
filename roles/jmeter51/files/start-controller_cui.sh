#!/bin/sh

DATE=$(date +"%Y%m%d")
OPTIME=$(date +"%Y%m%d-%H%M%S")
#結果の出力先ディレクトリを指定
LOGDIR=/var/www/html/${DATE}_tutorial
#JMXファイルを指定
FILE_JMX=/usr/local/jmeter/bin/templates/build-webservice-test-plan.jmx

#日付ディレクトリの作成
mkdir -p ${LOGDIR}

/usr/local/jmeter/bin/jmeter -Dsun.net.inetaddr.ttl=0 -n -t ${FILE_JMX} -j ${LOGDIR}/${OPTIME}.log -l ${LOGDIR}/${OPTIME}.jtl -e -o ${LOGDIR}/${OPTIME}_th${JMETER_THREAD}_tutorial_node${2}/ -r

DATE=$(date +"%Y%m%d")
ENDTIME=$(date +"%H:%M")
