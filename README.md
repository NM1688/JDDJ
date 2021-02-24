# Hydra_Scripts

#### 介绍
本库是用来同步大佬们的自定义js脚本，本人并不做任何脚本修改，保证原作者脚本的原汁原味  

#### 安装教程

修改自己的Hydra.sh文件，将本库地址添加到订阅目录  
https://raw.githubusercontent.com/Hydrahail-Johnson/Hydra_scripts/main/

#### 使用说明
适用于Docker2教程，需要修改Hydra.sh或者git_Hydra.sh文件，二选一，将本库地址添加到订阅目录，方法如下

##### 方法1 修改Hydra.sh
1. 在author_list=""添加作者名称，如Hydra，可以自定义
2. 添加本库链接  
在scripts_base_url_1=https://raw.githubusercontent.com/Hydrahail-Johnson/Hydra_scripts/main/  
注意url_1中数字为Hydra在author_list中顺序数字  
3. 在my_scripts_list_1=""中添加需要下载的脚本名字，建议全部添加  
注意list_1中数字为Hydra在author_list中顺序数字  
所有顺序做到一一对应
4. 保存修改

##### 方法2 修改git_Hydra.sh
1. git clone本项目到Hydrascripts  
git clone https://github.com/Hydrahail-Johnson/Hydra_scripts.git Hydra  
注意名字可以自己修改
2. 在Hydra.sh最后一行添加  
/bin/bash /jd/scripts/git_Hydra.sh Hydra
3. 保存修改

#### 参与贡献

[qiaoqi](https://github.com/qiao112)
[ktandykok](https://github.com/ktandykok)
[XINZHOUZHANG](https://github.com/XINZHOUZHANG)
[Nanase](https://github.com/jsyzdej)
