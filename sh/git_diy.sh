#!/usr/bin/env bash

diyscripts=/jd/diyscripts/
cd ${diyscripts}

##############################作者昵称（必填）##############################
# 使用空格隔开
author_list="Tartarus2014 i-chenzhe whyour moposmall qq34347476 ZCY01 shuye72"

##############################作者脚本地址URL（必填）##############################
# 例如：https://raw.githubusercontent.com/whyour/hundun/master/quanx/jx_nc.js
# 1.从作者库中随意挑选一个脚本地址，每个作者的地址添加一个即可，无须重复添加
# 2.将地址最后的 “脚本名称+后缀” 剪切到下一个变量里（my_scripts_list_xxx）
scripts_base_url_1=https://raw.githubusercontent.com/Tartarus2014/Script/master/
scripts_base_url_2=https://raw.githubusercontent.com/i-chenzhe/qx/main/
scripts_base_url_3=https://raw.githubusercontent.com/whyour/hundun/master/quanx/
scripts_base_url_4=https://raw.githubusercontent.com/moposmall/Script/main/Me/
scripts_base_url_5=https://raw.githubusercontent.com/qq34347476/js_script/master/scripts/
scripts_base_url_6=https://raw.githubusercontent.com/ZCY01/daily_scripts/main/jd/
scripts_base_url_7=https://gitee.com/shuye72/MyActions/raw/main/

##############################作者脚本名称（必填）##############################
# 将相应作者的脚本填写到以下变量中
# 维护:Tartarus2014 库地址:https://github.com/Tartarus2014/Script
my_scripts_list_1=""

# 维护:i-chenzhe   库地址:https://github.com/i-chenzhe/qx
my_scripts_list_2="jd_entertainment.js jd_fanslove.js jd_mlyjy.js jd_shake.js jd_shakeBean.js jd_shakeBean.js"

# 维护:whyour      库地址:https://github.com/whyour/hundun/tree/master/quanx
my_scripts_list_3="jd_zjd_tuan.js"

# 维护:moposmall   库地址:https://github.com/moposmall/Script/tree/main/Me
my_scripts_list_4="jx_cfd_exchange.js"

# 维护:qq34347476  库地址:https://github.com/qq34347476/js_script
my_scripts_list_5="format_share_jd_code.js"

# 维护:ZCY01       库地址:https://github.com/ZCY01/daily_scripts/tree/main/jd
my_scripts_list_6="jd_priceProtect.js"

# 维护:shuye72     库地址:https://gitee.com/shuye72/MyActions/tree/main ps:尽量不要使用此人脚本,
my_scripts_list_7=""


##############################随机函数##########################################
rand(){
    min=$1
    max=$(($2-$min+1))
    num=$(cat /proc/sys/kernel/random/uuid | cksum | awk -F ' ' '{print $1}')
    echo $(($num%$max+$min))
}

# cd $ScriptsDir   # 在 git_pull.sh 中已经定义 ScriptsDir 此变量，diy.sh 由 git_pull.sh 调用，因此可以直接使用此变量
index=1

for author in $author_list
do
  echo -e "开始下载 $author 的脚本"
  # 下载my_scripts_list中的每个js文件，重命名增加前缀"作者昵称_"，增加后缀".new"
  eval scripts_list=\$my_scripts_list_${index}
  #echo $scripts_list
  eval url_list=\$scripts_base_url_${index}
  #echo $url_list
  for js in $scripts_list
  do
    eval url=$url_list$js
    #echo $url
    eval name=$author"_"$js
    echo $name
    wget -q --no-check-certificate $url -O $name.new
  # 如果上一步下载没问题，才去掉后缀".new"，如果上一步下载有问题，就保留之前正常下载的版本
    if [ $? -eq 0 ]; then
      mv -f $name.new $name
      echo -e "更新 $name 完成...\n"
    else
      [ -f $name.new ] && rm -f $name.new
      echo -e "更新 $name 失败，使用上一次正常的版本...\n"
    fi
  done
  index=$[$index+1]
done   
echo -e "自定义脚本下载完成\n"

if [ $# != 1 ] ; then
  echo "USAGE: $0 jsname"
  exit 1;
fi

jsname=$1

rand(){
    min=$1
    max=$(($2-$min+1))
    num=$(cat /proc/sys/kernel/random/uuid | cksum | awk -F ' ' '{print $1}')
    echo $(($num%$max+$min))
}

function addnewcron {
  addname=""
  cd ${diyscripts}
    for js in `ls *.js`;
      do 
        croname=`echo "$js"|awk -F\. '{print $1}'`
        script_date=`cat  $js|grep ^[0-9]|awk '{print $1,$2,$3,$4,$5}'|sort |uniq|head -n 1`
        [ -z "${script_date}" ] && script_date=`cat  $js|grep -Eo "([0-9]+|\*|[0-9]+[,-].*) ([0-9]+|\*|[0-9]+[,-].*) ([0-9]+|\*|[0-9]+[,-].*) ([0-9]+|\*|[0-9]+[,-].*) ([0-9]+|\*|[0-9][,-].*)"|sort |uniq|head -n 1`
        [ -z "${script_date}" ] && cron_min=$(rand 1 59) && cron_hour=$(rand 7 9) && script_date="${cron_min} ${cron_hour} * * *"
        [ $(grep -c -w "$croname" /jd/config/crontab.list) -eq 0 ] && sed -i "/hangup/a${script_date} bash jd $croname"  /jd/config/crontab.list && addname="${addname}\n${croname}" && echo -e "添加了新的脚本${croname}."
        if [ ! -f "/jd/scripts/$croname" ];then
              \cp $js /jd/scripts/$croname
        else
             change=$(diff $js /jd/scripts/$croname)
             [ -n "${change}" ] && \cp $js /jd/scripts/$croname && echo -e "$croname 脚本更新了."
        fi
        done
       [ "$addname" != "" ] && [ -f "/jd/scripts/sendinfo.sh" ] && /bin/bash  /jd/scripts/sendinfo.sh "新增自定义脚本" "${addname}"
  }

function delcron {
  delname=""
  cronfiles=$(grep "$jsname" /jd/config/crontab.list|grep -v "^#"|awk -F"$jsname" '{print $2}')
    for filename in $cronfiles;
      do
       if [ ! -f "${diyscripts}/${filename}.js" ]; then 
         sed -i "/\<bash jd ${filename}\>/d" /jd/config/crontab.list && echo -e "删除失效脚本${filename}."
	       delname="${delname}\n${filename}"
       fi
      done
      [ "$delname" != "" ] && [ -f "/jd/scripts/sendinfo.sh" ] && /bin/bash  /jd/scripts/sendinfo.sh  "删除失效脚本" "${delname}" 
  }

if [[ ${gitpullstatus} -eq 0 ]]
  then
  addnewcron
  delcron
else
  echo -e "仓库更新失败了."
  [ -f "/jd/scripts/sendinfo.sh" ] && /bin/bash  /jd/scripts/sendinfo.sh "自定义仓库更新失败" "自定义仓库更新失败"
fi

exit 0


