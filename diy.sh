 #!/usr/bin/env bash

##############################作者昵称（必填）##############################
# 使用空格隔开
author_list="jaindjh i-chenzhe normal Hydrahail-Johnson qq34347476 cui521 member"

##############################作者脚本地址URL（必填）##############################
# 例如：https://raw.githubusercontent.com/whyour/hundun/master/quanx/jx_nc.js
# 1.从作者库中随意挑选一个脚本地址，每个作者的地址添加一个即可，无须重复添加
# 2.将地址最后的 “脚本名称+后缀” 剪切到下一个变量里（my_scripts_list_xxx）
scripts_base_url_1=https://gitee.com/jiandjh/docker/raw/main/jd/
scripts_base_url_2=https://gitee.com/mumuba2020/dust/raw/dust/i-chenzhe/
scripts_base_url_3=https://gitee.com/mumuba2020/dust/raw/dust/normal/
scripts_base_url_4=https://ghproxy.com/https://raw.githubusercontent.com/Hydrahail-Johnson/scripts/main/js/
scripts_base_url_5=https://ghproxy.com/https://raw.githubusercontent.com/qq34347476/js_script/master/scripts/
scripts_base_url_6=https://ghproxy.com/https://raw.githubusercontent.com/cui521/jdqd/main/
scripts_base_url_7=https://gitee.com/mumuba2020/dust/raw/dust/member/

##############################作者脚本名称（必填）##############################
# 将相应作者的脚本填写到以下变量中
my_scripts_list_1="jd_jxnc.js jd_back_carnivalcity.js jd_carnivalcity.js jd_cash.js jd_crazy_joy_collect.js jd_crazy_joy_compose.js jd_priceProtect.js jd_speed_redpocke.js 
jx_cfd.js xiaomi-step.js monk_inter_shop_sign.js"
my_scripts_list_2="z_carnivalcity.js z_entertainment.js z_fanslove.js z_marketLottery.js z_mother_jump.js z_shake.js z_super5g.js"
my_scripts_list_3="monk_inter_shop_sign.js monk_shop_follow_sku.js monk_shop_lottery.js monk_skyworth.js"
my_scripts_list_4="jd_try.js jx_cfd_exchange.js"
my_scripts_list_5="format_share_jd_code.js"
my_scripts_list_6="DIY_shopsign.js"
my_scripts_list_7="monk_pasture.js"

##############################随机函数##########################################
rand(){
    min=$1
    max=$(($2-$min+1))
    num=$(cat /proc/sys/kernel/random/uuid | cksum | awk -F ' ' '{print $1}')
    echo $(($num%$max+$min))
}


cd $ScriptsDir   # 在 git_pull.sh 中已经定义 ScriptsDir 此变量，diy.sh 由 git_pull.sh 调用，因此可以直接使用此变量
index=1

for author in $author_list
do
  echo -e "####################开始下载 $author 的脚本####################"
  # 下载my_scripts_list中的每个js文件，重命名增加前缀"作者昵称_"，增加后缀".new"
  eval scripts_list=\$my_scripts_list_${index}
  echo $scripts_list
  eval url_list=\$scripts_base_url_${index}
  for js in $scripts_list
  do
    eval url=$url_list$js
    echo $url
    check_file=`ls|grep "$js"`
    if [ ! $check_file ]; then
      check_file="blank"
    fi
    existing_file_num=`echo "$check_file"|awk 'END{print NR}'`
    if [[ "$existing_file_num" -eq "1" ]] && [ ${check_file} == ${js} ]; then
      echo -e "库中已存在该脚本 $js ,将不进行任何操作"
      continue
    else
      if [ ${check_file} == "blank" ]; then
        eval name=$author"_"$js
        echo $name"--发现新脚本"
      else
        for js_name in $check_file
        do
          if [ ${js_name} != ${js} ] && [[ "$existing_file_num" -gt "1" ]]; then
            rm -f "$js_name"
            echo -e "已删除一个重复的 $js 脚本"
          else
            eval name=$author"_"$js
            echo $name"--只发现1个脚本，故继续保留作者前缀"
          fi
        done
      fi

    # 如果上一步下载没问题，才去掉后缀".new"，如果上一步下载有问题，就保留之前正常下载的版本
      if [ $? -eq 0 ]; then
        mv -f $name.new $name
        echo -e "更新 $name 完成..."
	    croname=`echo "$name"|awk -F\. '{print $1}'`
	    script_date=`cat  $name|grep "http"|awk '{if($1~/^[0-59]/) print $1,$2,$3,$4,$5}'|sort |uniq|head -n 1`
	    [ -z "${script_date}" ] && script_date=`cat  $name|grep -Eo "([0-9]+|\*) ([0-9]+|\*) ([0-9]+|\*) ([0-9]+|\*) ([0-9]+|\*)"|sort |uniq|head -n 1`
	    if [ -z "${script_date}" ]; then
	      cron_min=$(rand 1 59)
	      cron_hour=$(rand 7 9)
	  	  [ $(grep -c "$croname" /jd/config/crontab.list) -eq 0 ] && sed -i "/hangup/a${cron_min} ${cron_hour} * * * bash jd $croname"  /jd/config/crontab.list
	    else
	      check_existing_cron=`grep -c "$croname" /jd/config/crontab.list`
	      echo $check_existing_cron"准备添加cron"
	      if [ "${check_existing_cron}" -eq 0 ]; then
	        sed -i "/hangup/a${script_date} bash jd $croname"  /jd/config/crontab.list
	        echo -e "已成功添加新cron...\n"
	      else
	        grep -v "$croname" /jd/config/crontab.list > output.txt
		      mv -f output.txt /jd/config/crontab.list
		      sed -i "/hangup/a${script_date} bash jd $croname"  /jd/config/crontab.list
	        echo -e "已成功替换cron...\n"
	      fi
	    fi
      else
        [ -f $name.new ] && rm -f $name.new
        echo -e "更新 $name 失败，使用上一次正常的版本...\n"
        croname=`echo "$name"|awk -F\. '{print $1}'`
        check_existing_cron=`grep -c "$croname" /jd/config/crontab.list`
        if [ "${check_existing_cron}" -ne 0 ]; then
          grep -v "$croname" /jd/config/crontab.list > output.txt
          mv -f output.txt /jd/config/crontab.list
          echo -e "已成功删除"$name"的crontablist\n"
          rm ${name:-default}
          echo -e "已成功删除"$name"的脚本文件\n"
          cd $LogDir
          rm -r ${croname:-default}
          echo -e "已成功删除"$name"的log文件夹\n"
        fi
      fi
    fi
  done
  index=$[$index+1]
done

##############################同步 diy.sh ##########################################
cd $ConfigDir
echo -e "开始更新 diy.sh "
wget -q --no-check-certificate https://gitee.com/jiandjh/docker/raw/main/diy.sh -O diy.sh.new
if [ $? -eq 0 ]; then
  mv -f diy.sh.new diy.sh
  echo -e "更新 diy.sh 完成"
else
  rm -rf diy.sh.new
  echo -e "更新 diy.sh 失败，使用上一次正常的版本...\n"
fi