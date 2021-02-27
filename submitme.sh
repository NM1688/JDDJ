#!/bin/sh
#脚本在容器内执行,位置自己随意,然后添加crontab的时间需要晚于qq34347476_format_share_jd_code 执行时间.
#log为qq34347476_format_share_jd_code 脚本生成的日志,因为lxk的日志格式有点乱,
#需要目录内有当天生成的日志文件,否则不运行.
#logdir改成自己容器日志的目录地址.以下如默认则不用改

source /etc/profile

today=`date -d "-1 day" +"%Y-%m-%d"`
logdir=/jd/log/*_format_share_jd_code/
log=`find $logdir  -type f -mtime -2 |head -n 1`
mkdir -p /jd/log/submitme
execlog=/jd/log/submitme/$(date +"%Y-%m-%d-%H-%M").log

getformat() {
    if [ $(find /jd/scripts/ -type f -name "*format_share_jd_code.js"|wc -l) -eq 0 ];then
	    echo -e "格式化脚本不存在,准备下载...\n" >> $execlog
	    cd /jd/scripts/;wget https://gitee.com/qq34347476/quantumult-x/raw/master/format_share_jd_code.js && bash jd format_share_jd_code now 
        echo -e "格式化脚本执行完毕!\n" >> $execlog
    fi
} 

submit() {
    logfile=$1
    cat $logfile |grep -v "^#"|awk '/东东工厂/'|sed 's/.*（\(.*\)）.*】\(.*\)/\1 \2/g'|awk '{print "curl -s \"http://47.100.61.159:10080/add?user="$1"&code="$2"&type=ddfactory\""}'|bash
	sleep 1
    cat $logfile |grep -v "^#"|awk '/京喜工厂/'|sed 's/.*（\(.*\)）.*】\(.*\)/\1 \2/g'|awk '{print "curl -s \"http://47.100.61.159:10080/add?user="$1"&code="$2"&type=jxfactory\""}'|bash
	sleep 1
    cat $logfile |grep -v "^#"|awk '/京喜农场助力码/'|sed 's/.*（\(.*\)）.*】\(.*\)/\1 \2/g'|awk '{print "curl -s \"http://47.100.61.159:10080/add?user="$1"&code="$2"&type=jxfarm\""}'|bash
	sleep 1
    cat $logfile |grep -v "^#"|awk '/京东萌宠/'|sed 's/.*（\(.*\)）.*】\(.*\)/\1 \2/g'|awk '{print "curl -s \"http://47.100.61.159:10080/add?user="$1"&code="$2"&type=pet\""}'|bash
	sleep 1
    cat $logfile |grep -v "^#"|awk '/种豆得豆/'|sed 's/.*（\(.*\)）.*】\(.*\)/\1 \2/g'|awk '{print "curl -s \"http://47.100.61.159:10080/add?user="$1"&code="$2"&type=bean\""}'|bash
	sleep 1
    cat $logfile |grep -v "^#"|awk '/京东农场/'|sed 's/.*（\(.*\)）.*】\(.*\)/\1 \2/g'|awk '{print "curl -s \"http://47.100.61.159:10080/add?user="$1"&code="$2"&type=farm\""}'|bash
	sleep 1
    cat $logfile |grep -v "^#"|awk '/京东赚赚/'|sed 's/.*（\(.*\)）.*】\(.*\)/\1 \2/g'|awk '{print "curl -s \"http://47.100.61.159:10080/add?user="$1"&code="$2"&type=jdzz\""}'|bash
	sleep 1
    cat $logfile |grep -v "^#"|awk '/crazyJoy/'|sed 's/.*（\(.*\)）.*】\(.*\)/\1 \2/g'|awk '{print "curl -s \"http://47.100.61.159:10080/add?user="$1"&code="$2"&type=jdcrazyjoy\""}'|bash
	sleep 1
    cat $logfile |grep -v "^#"|awk '/京东签到领现金/'|sed 's/.*（\(.*\)）.*】\(.*\)/\1 \2/g'|awk '{print "curl -s \"http://47.100.61.159:10080/add?user="$1"&code="$2"&type=jdcash\""}'|bash
	sleep 1
    cat $logfile |grep -v "^#"|awk '/闪购盲盒/'|sed 's/.*（\(.*\)）.*】\(.*\)/\1 \2/g'|awk '{print "curl -s \"http://47.100.61.159:10080/add?user="$1"&code="$2"&type=sgmh\""}'|bash
    echo -e "提交助力码成功\n" >> $execlog
}


getme() {
    accnum=6
    configfile=/jd/config/config.sh
    cp ${configfile} /jd/config/bak/config.sh.$(date +%s)
    
    
    farm=`curl -s http://47.100.61.159:10080/farm`
    pet=`curl -s http://47.100.61.159:10080/pet`
    bean=`curl -s http://47.100.61.159:10080/bean`
    jxfactory=`curl -s http://47.100.61.159:10080/jxfactory`
    ddfactory=`curl -s http://47.100.61.159:10080/ddfactory`
    pdzz=`curl -s http://47.100.61.159:10080/jdzz`
    jdcrazyjoy=`curl -s http://47.100.61.159:10080/jdcrazyjoy`
    jxfarm=`curl -s http://47.100.61.159:10080/jxfarm`
    jdcash=`curl -s http://47.100.61.159:10080/jdcash`
    sgmh=`curl -s http://47.100.61.159:10080/sgmh`
    
    i=1
    while [ $i -le $accnum ];do
      [ $(grep "ForOtherFruit$i" ${configfile}|grep -c '}') -gt 0 ] && sed -i "s/ForOtherFruit$i=\"\(.*}\).*\"/ForOtherFruit$i=\"\1@${farm}\"/g" ${configfile} || sed -i "s/ForOtherFruit$i=\".*\"/ForOtherFruit$i=\"${farm}\"/g" ${configfile}
      [ $(grep "ForOtherPet$i" ${configfile}|grep -c '}') -gt 0 ] && sed -i "s/ForOtherPet$i=\"\(.*}\).*\"/ForOtherPet$i=\"\1@${pet}\"/g" ${configfile} || sed -i "s/ForOtherPet$i=\".*\"/ForOtherPet$i=\"${pet}\"/g" ${configfile}
      [ $(grep "ForOtherBean$i" ${configfile}|grep -c '}') -gt 0 ] && sed -i "s/ForOtherBean$i=\"\(.*}\).*\"/ForOtherBean$i=\"\1@${bean}\"/g" ${configfile} || sed -i "s/ForOtherBean$i=\".*\"/ForOtherBean$i=\"${bean}\"/g" ${configfile}
      [ $(grep "ForOtherDreamFactory$i" ${configfile}|grep -c '}') -gt 0 ] && sed -i "s/ForOtherDreamFactory$i=\"\(.*}\).*\"/ForOtherDreamFactory$i=\"\1@${jxfactory}\"/g" ${configfile} || sed -i "s/ForOtherDreamFactory$i=\".*\"/ForOtherDreamFactory$i=\"${jxfactory}\"/g" ${configfile}
      [ $(grep "ForOtherJdFactory$i" ${configfile}|grep -c '}') -gt 0 ] && sed -i "s/ForOtherJdFactory$i=\"\(.*}\).*\"/ForOtherJdFactory$i=\"\1@${ddfactory}\"/g" ${configfile} || sed -i "s/ForOtherJdFactory$i=\".*\"/ForOtherJdFactory$i=\"${ddfactory}\"/g" ${configfile}
      #[ $(grep "ForOtherJdzz$i" ${configfile}|grep -c '}') -gt 0 ] && sed -i "s/ForOtherJdzz$i=\"\(.*}\).*\"/ForOtherJdzz$i=\"\1@${jdzz}\"/g" ${configfile} || sed -i "s/ForOtherJdzz$i=\".*\"/ForOtherJdzz$i=\"${jdzz}\"/g" ${configfile}
      [ $(grep "ForOtherJoy$i" ${configfile}|grep -c '}') -gt 0 ] && sed -i "s/ForOtherJoy$i=\"\(.*}\).*\"/ForOtherJoy$i=\"\1@${jdcrazyjoy}\"/g" ${configfile} || sed -i "s/ForOtherJoy$i=\".*\"/ForOtherJoy$i=\"${jdcrazyjoy}\"/g" ${configfile}
      #[ $(grep "ForOtherJxnc$i" ${configfile}|grep -c '}') -gt 0 ] && sed -i "s/ForOtherJxnc$i=\"\(.*}\).*\"/ForOtherJxnc$i=\"\1@${jxfarm}\"/g" ${configfile} || sed -i "s/ForOtherJxnc$i=\".*\"/ForOtherJxnc$i=\"${jxfarm}\"/g" ${configfile}
      [ $(grep "ForOtherCash$i" ${configfile}|grep -c '}') -gt 0 ] && sed -i "s/ForOtherCash$i=\"\(.*}\).*\"/ForOtherCash$i=\"\1@${jdcash}\"/g" ${configfile} || sed -i "s/ForOtherCash$i=\".*\"/ForOtherCash$i=\"${jdcash}\"/g" ${configfile}
      [ $(grep "ForOtherSgmh$i" ${configfile}|grep -c '}') -gt 0 ] && sed -i "s/ForOtherSgmh$i=\"\(.*}\).*\"/ForOtherSgmh$i=\"\1@${sgmh}\"/g" ${configfile} || sed -i "s/ForOtherSgmh$i=\".*\"/ForOtherSgmh$i=\"${sgmh}\"/g" ${configfile}
      let i++
    done
    echo -e "添加助力码到本地配置文件成功!" >> $execlog

}


getformat
sleep 1
[ -f "$log" ] && submit $log && sleep 5 && getme
