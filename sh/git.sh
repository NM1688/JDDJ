 #!/usr/bin/bash
source /etc/profile

##########################################################
#                                                        #
#                      拉取自定义脚本                      # 
#                                                        #
##########################################################

####################  作者列表  ###########################

author_list="i-chenzhe moposmall whyour qq34347476 ZCY01 shuye72"

#################### 作者脚本地址URL #######################
scripts_base_url_1=https://raw.githubusercontent.com/i-chenzhe/qx/main/
scripts_base_url_2=https://raw.githubusercontent.com/moposmall/Script/main/Me/
scripts_base_url_3=https://raw.githubusercontent.com/whyour/hundun/master/quanx/
#scripts_base_url_4=https://gitee.com/qq34347476/quantumult-x/raw/master/
scripts_base_url_4=https://raw.githubusercontent.com/qq34347476/js_script/master/scripts/
scripts_base_url_5=https://raw.githubusercontent.com/ZCY01/daily_scripts/main/jd/
scripts_base_url_6=https://gitee.com/shuye72/MyActions/raw/main/

#####################  作者脚本名称 ##########################
#维护:i-chenzhe     库地址:https://github.com/i-chenzhe/qx
my_scripts_list_1="jd_entertainment.js jd_fanslove.js jd_jump-jump.js jd_shake.js jd_gjmh.js jd_shakeBean.js jd_xmf.js z_marketLottery.js" 

#维护:moposmall     库地址:https://github.com/moposmall/Script/tree/main/Me
my_scripts_list_2="jx_cfd_exchange.js"

# 维护:whyour       库地址:https://github.com/whyour/hundun/tree/master/quanx
my_scripts_list_3=""

# 维护:qq34347476   库地址:https://gitee.com/qq34347476/quantumult-x
my_scripts_list_4="format_share_jd_code.js"

# 维护:ZCY01        库地址:https://github.com/ZCY01/daily_scripts/tree/main/jd
my_scripts_list_5=""

# 维护:shuye72      库地址:https://gitee.com/shuye72/MyActions/tree/main ps:尽量不要使用此人脚本,
my_scripts_list_6=""

######################  是否使用本地代理  ######################
Enableproxy="false"

######################### 脚本保存位置 #########################   
cd /etc/github/diy_scripts/
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

    # wget下载是否使用代理
    if [ "${Enableproxy}" = "true" ]; then
        echo -e "使用代理下载"
        wget -q -e "https_proxy=socks5://127.0.0.1:8118" --no-check-certificate $url -O $name.new
    else
        echo -e "不使用代理下载"
        wget -q --no-check-certificate $url -O $name.new
    fi

    # 如果上一步下载没问题，才去掉后缀".new"，如果上一步下载有问题，就保留之前正常下载的版本
      if [ $? -eq 0 ]; then
        mv -f $name.new $name
        echo -e "更新 $name 完成..."
      else
        [ -f $name.new ] && rm -f $name.new
        echo -e "更新 $name 失败，使用上一次正常的版本...\n"        
      fi
    fi
  done
  index=$[$index+1]
done
#exit 0
