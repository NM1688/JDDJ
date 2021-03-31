#!/usr/bin/env bash

##############################################################################
#                                                                            #
#                          自动拉取各个作者库内指定脚本
#                   把此diy.sh放入config即可,会自动同步最新脚本
#                    如有好用的脚本或者脚本更新不及时请@qiao112
#                              2021年3月31日
#                                                                            #
##############################################################################

############################## 作者名称 ##############################
author_list="
Tartarus2014
i-chenzhe
whyour
moposmall
qq34347476
ZCY01
cui521
monk-coder

"
######################################################################

############################## 维护:Tartarus2014 ##############################
# 库地址:https://github.com/Tartarus2014/Script
scripts_base_url_1=https://ghproxy.com/https://raw.githubusercontent.com/Tartarus2014/Script/master/
my_scripts_list_1="

"

############################## 维护:i-chenzhe ##############################
# 库地址:https://github.com/monk-coder/dust/tree/dust/i-chenzhe
scripts_base_url_2=https://ghproxy.com/https://raw.githubusercontent.com/monk-coder/dust/dust/i-chenzhe/
my_scripts_list_2="
z_entertainment.js
z_fanslove.js
z_getFanslove.js
z_marketLottery.js
z_mother_jump.js
z_shake.js
z_super5g.js

"

############################## 维护:whyour ##############################
# 库地址:https://github.com/whyour/hundun/tree/master/quanx
scripts_base_url_3=https://ghproxy.com/https://raw.githubusercontent.com/whyour/hundun/master/quanx/
my_scripts_list_3="
jd_zjd_tuan.js

"

############################## 维护:moposmall ##############################
# 库地址:https://github.com/moposmall/Script/tree/main/Me
scripts_base_url_4=https://ghproxy.com/https://raw.githubusercontent.com/moposmall/Script/main/Me/
my_scripts_list_4="
jx_cfd_exchange.js

"

############################## 维护:qq34347476 ##############################
# 库地址:https://github.com/qq34347476/js_script
scripts_base_url_5=https://ghproxy.com/https://raw.githubusercontent.com/qq34347476/js_script/master/scripts/
my_scripts_list_5="
format_share_jd_code.js
getShareCode_format.js
jd_try.js
submit_codes.js 

"

############################## 维护:ZCY01 ##############################
# 库地址:https://github.com/ZCY01/daily_scripts/tree/main/jd
scripts_base_url_6=https://ghproxy.com/https://raw.githubusercontent.com/ZCY01/daily_scripts/main/jd/
my_scripts_list_6="
jd_priceProtect.js

"

############################## 维护:cui521 ##############################
# 库地址:https://github.com/cui521/jdqd
scripts_base_url_7=https://ghproxy.com/https://raw.githubusercontent.com/cui521/bilibili/main2/BiliClient/
my_scripts_list_7="
DIY_shopsign.js

"

############################## 维护:monk-coder ##########################
# 库地址:https://github.com/monk-coder/dust/tree/dust/normal
scripts_base_url_8=https://ghproxy.com/https://raw.githubusercontent.com/monk-coder/dust/dust/normal/
my_scripts_list_8="
monk_inter_shop_sign.js
monk_shop_follow_sku.js
monk_shop_lottery.js

"
############################ 是否强制替换脚本的定时 ############################
# 设为"true"时强制替换脚本的定时，设为"false"则不替换脚本的定时...
Enablerenew="false"

############################## 随机函数 ##############################
rand(){
    min=$1
    max=$(($2-$min+1))
    num=$(cat /proc/sys/kernel/random/uuid | cksum | awk -F ' ' '{print $1}')
    echo $(($num%$max+$min))
}

############################## 手动删除失效脚本 ##############################
cd $ScriptsDir
# rm -rf qq34347476_getShareCode_format.js

############################## 开始下载脚本 ##############################
index=1
for author in $author_list
do
  echo -e "######################### 开始下载 $author 的脚本 #########################"
  # 下载my_scripts_list中的每个js文件，重命名增加前缀"作者昵称_"，增加后缀".new"
  eval scripts_list=\$my_scripts_list_${index}
  eval url_list=\$scripts_base_url_${index}
  for js in $scripts_list
  do
    eval url=$url_list$js
    eval name=$author"_"$js
    echo $name
    wget -q --no-check-certificate $url -O $name.new

    # 如果上一步下载没问题，才去掉后缀".new"，如果上一步下载有问题，就保留之前正常下载的版本
    if [ $? -eq 0 ]; then
      mv -f $name.new $name
      echo -e "$name 更新成功!!!"
	  croname=`echo "$name"|awk -F\. '{print $1}'`
	  script_date=`cat  $name|grep "http"|awk '{if($1~/^[0-59]/) print $1,$2,$3,$4,$5}'|sort |uniq|head -n 1`
	  [ -z "${script_date}" ] && script_date=`cat  $name|grep -Eo "([0-9]+|\*) ([0-9]+|\*) ([0-9]+|\*) ([0-9]+|\*) ([0-9]+|\*)"|sort |uniq|head -n 1`
	  if [ -z "${script_date}" ]; then
	    cron_min=$(rand 1 59)
	    cron_hour=$(rand 7 9)
      [ $(grep -c "$croname" ${ConfigDir}/crontab.list) -eq 0 ] && sed -i "/hangup/a${cron_min} ${cron_hour} * * * bash jd $croname"  ${ConfigDir}/crontab.list
	  else
	    check_existing_cron=`grep -c "$croname" ${ConfigDir}/crontab.list`
	    echo $name "开始添加定时..."
	    if [ "${check_existing_cron}" -eq 0 ]; then
	      sed -i "/hangup/a${script_date} bash jd $croname"  ${ConfigDir}/crontab.list
	      echo -e "$name 成功添加定时!!!\n"
	    else
	      if [ "${Enablerenew}" = "true" ]; then
	      	echo -e "检测到"$name"定时已存在开始替换...\n"
	        grep -v "$croname" ${ConfigDir}/crontab.list > output.txt
		      mv -f output.txt ${ConfigDir}/crontab.list
		      sed -i "/hangup/a${script_date} bash jd $croname"  ${ConfigDir}/crontab.list
	        echo -e "替换"$name"定时成功!!!"
	      else
	        echo -e "$name 存在定时,已选择不替换...\n"
	      fi
	    fi
	  fi
    else
      [ -f $name.new ] && rm -f $name.new
      echo -e "$name 脚本失效,已删除脚本...\n"
      croname=`echo "$name"|awk -F\. '{print $1}'`
      check_existing_cron=`grep -c "$croname" ${ConfigDir}/crontab.list`
      if [ "${check_existing_cron}" -ne 0 ]; then
        grep -v "$croname" ${ConfigDir}/crontab.list > output.txt
        mv -f output.txt ${ConfigDir}/crontab.list
        echo -e "检测到"$name"残留文件..."
        rm -f ${name:-default}
        echo -e "开始清理"$name"残留文件..."
        cd $LogDir
        rm -rf ${croname:-default}
        echo -e "清理"$name"残留文件完成!!!\n"
        cd $ScriptsDir
      fi
    fi
  done
  index=$[$index+1]
done

############################## 修改更新频率 ##############################
echo -e "开始修改更新频率"
if [ -f ${ListCron} ]; then
  cron_min=$(rand 1 30) 
  perl -i -pe "s|.+(bash git_pull.+)|${cron_min} \* \* \* \* \1|" ${ListCron}
  crontab ${ListCron}
  echo -e "修改更新频率成功!!!"
else
  echo -e "修改更新时间失败..."
fi

############################## 更新群助力脚本 ##############################
bash ${ConfigDir}/sharecode.sh

############################## 恢复HomePage ##############################
panelDir=${ShellDir}/panel/public
cd $panelDir
echo -e "恢复HomePage"
wget -q --no-check-certificate https://gitee.com/qq34347476/quantumult-x/raw/master/pannel/public/home.html -O home.html.new
if [ $? -eq 0 ]; then
  mv -f home.html.new home.html
  echo -e "恢复 HomePage 成功!!!"
else
  rm -rf home.html.new
  echo -e "恢复 HomePage 失败...\n"
fi

############################## 更新diy.sh ##############################
cd $ConfigDir
echo -e "开始更新 diy.sh "
wget -q --no-check-certificate https://ghproxy.com/https://raw.githubusercontent.com/Hydrahail-Johnson/diy_scripts/main/diy.sh?token=AK445WTSDL2EG7G26DVSUNLALXMQ2 -O diy.sh.new
if [ $? -eq 0 ]; then
  mv -f diy.sh.new diy.sh
  echo -e "更新 diy.sh 成功!!!"
else
  rm -rf diy.sh.new
  echo -e "更新 diy.sh 失败...\n"
fi
