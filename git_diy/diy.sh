 #!/usr/bin/env bash

# 把此diy.sh放入config即可,会自动同步最新脚本
# 如有好用的脚本或者脚本更新不及时请@qiao112、@Hydra或者其他群管，大家都有权限修改github文件
# 如需参加宠汪汪助力请把昵称提交给@Mr.spark，群助力池不包含宠汪汪
# 昵称获取:可在京东APP->我的->设置 查看获得
# 2021年3月24日18:23

############################## 更新群助力脚本 ##############################
bash /jd/config/qunsharecode.sh

############################## 使用git_diy ##############################
#git clone https://github.com/Hydrahail-Johnson/diy_scripts.git Hydra
#bash /jd/config/git_diy.sh Hydra

############################## 宠汪汪群助力 ##############################
##ls /jd/config/help_pet_run.sh && bash /jd/config/help_pet_run.sh || wget -O /jd/config/help_pet_run.sh http://47.100.61.159:81/help_pet_run.sh

############################## 自动更新diy.sh 脚本 ##############################
cd $ConfigDir
echo -e "开始更新 diy.sh "
wget -q --no-check-certificate https://ghproxy.com/https://raw.githubusercontent.com/Hydrahail-Johnson/diy_scripts/main/git_diy/diy.sh -O diy.sh.new
if [ $? -eq 0 ]; then
  mv -f diy.sh.new diy.sh
  echo -e "更新 diy.sh 完成"
else
  rm -rf diy.sh.new
  echo -e "更新 diy.sh 失败，使用上一次正常的版本...\n"
fi
