# Hydra_Scripts

#### 介绍
本库是用来同步大佬们的自定义js脚本，本人并不做任何脚本修改，保证原作者脚本的原汁原味  

#### 安装教程

修改自己的diy.sh文件，将本库地址添加到订阅目录  
https://raw.githubusercontent.com/Hydrahail-Johnson/diy_scripts/main/

#### 使用说明
适用于Docker2教程，需要修改diy.sh或者git_diy.sh文件，多选一，将本库地址添加到订阅目录，方法如下

##### 方法1. 修改diy.sh （最简单，适合小白用户）
1. 从网页上复制diy.sh文件的内容，在web面板中替换自己原有的自定义任务后，保存修改。
diy.sh下载地址：https://raw.githubusercontent.com/Hydrahail-Johnson/diy_scripts/main/sh/git.sh

##### 方法2. 修改diy.sh （次简单，适合爱折腾用户）
在web面板修改自定义任务，修改内容如下：
1. 在author_list=""添加作者名称，如Hydra，可以自定义
2. 添加本库链接  
在scripts_base_url_1=https://raw.githubusercontent.com/Hydrahail-Johnson/diy_scripts/main/  
注意url_1中数字为Hydra在author_list中顺序数字  
3. 在my_scripts_list_1=""中添加需要下载的脚本名字，建议全部添加  
注意list_1中数字为Hydra在author_list中顺序数字  
所有顺序做到一一对应
4. 保存修改

##### 方法3. 修改git_diy.sh （较难，适合超爱折腾用户）
1. git clone本项目到/diyscripts目录  
git clone https://github.com/Hydrahail-Johnson/diy_scripts.git Hydra  
注意名字可以自己修改
2. 在diy.sh最后一行添加  
/bin/bash /jd/scripts/git_diy.sh Hydra
3. 保存修改

#### 注意事项
方法1和方法2依赖于git_pull的更新时间，可能更新不够及时，如果介意请使用方法3。

#### 小福利
由于国内用户github访问过慢，下载速度垃圾，提供一个本人搭建的github加速节点，仅支持小文件加速
https://github.zjxnas.tk

#### 参与贡献

[qiaoqi](https://github.com/qiao112)
[ktandykok](https://github.com/ktandykok)
[XINZHOUZHANG](https://github.com/XINZHOUZHANG)
[Nanase](https://github.com/jsyzdej)
