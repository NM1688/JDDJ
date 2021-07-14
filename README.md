#依次运行以下命令，安装jd_v4_bot和面板。


1、安装v4_bot (x86) 一键命令（1）

  (如是群晖用户，提前在docker下新建文件夹jd_v4_bot，下面再新建config，log，own，diy，scripts五个文件夹，左边路径改为实际的绝对路径。)
  
  (强烈建议：自行修改本地宿主机端口，即修改左边的5678。)
  
    docker run -dit \
      -v /jd_v4_bot/config:/jd/config \
      -v /jd_v4_bot/log:/jd/log \
      -v /jd_v4_bot/own:/jd/own \
      -v /jd_v4_bot/diy:/jd/jbot/diy \
      -v /jd_v4_bot/scripts:/jd/scripts \
      -p 5678:5678 \
      -e ENABLE_HANGUP=true \
      -e ENABLE_WEB_PANEL=true \
      --name jd_v4_bot \
      --hostname jd_v4_bot \
      --restart always \
      annyooo/jd:v4_bot



1.1、安装v4_bot (x86) 一键命令（2）

    wget -q https://raw.githubusercontent.com/Annyoo2021/jd_v4_bot/main/jd-docker.sh -O jd-docker.sh && chmod +x jd-docker.sh && ./jd-docker.sh


2、安装v4_bot (arm64) 一键命令（1）

  (强烈建议：自行修改本地宿主机端口，即修改左边的5678。)
  
    docker run -dit \
      -v /jd_v4_bot/config:/jd/config \
      -v /jd_v4_bot/log:/jd/log \
      -v /jd_v4_bot/own:/jd/own \
      -v /jd_v4_bot/diy:/jd/jbot/diy \
      -v /jd_v4_bot/scripts:/jd/scripts \
      -p 5678:5678 \
      -e ENABLE_HANGUP=false \
      -e ENABLE_WEB_PANEL=true \
      --name jd_v4_bot \
      --hostname jd_v4_bot \
      --restart always \
      annyooo/jd:v4_bot_arm64



2.1、安装v4_bot (arm64) 一键命令（2）

    wget -q https://raw.githubusercontent.com/Annyoo2021/jd_v4_bot/main/jd-docker_0.sh -O jd-docker_0.sh && chmod +x jd-docker_0.sh && ./jd-docker_0.sh

   
3、进入容器，默认容器名jd_v4_bot，如做了修改，按实际修改命令。

    docker exec -it jd_v4_bot bash 


 
4、安装面板，已去除ttyd终端，(切记先要进入容器再执行)。

   执行以下命令后，请访问5678端口进行配置，如果你做了修改，请使用实际端口进行访问，默认用户名admin，密码adminadmin。
   
   （强烈建议：仅本地使用面板。）
 
    wget -q https://raw.githubusercontent.com/Annyoo2021/jd_v4_bot/main/v4mb.sh -O v4mb.sh && chmod +x v4mb.sh && ./v4mb.sh
 



5、镜像默认用我的库作为主库，三方库自行添加。装好更新后，安装某些脚本所需依赖：

 （依次执行以下命令，默认容器名jd_v4_bot，如做了修改，按实际修改命令。）

    docker exec -it jd_v4_bot bash
    
    cd scripts && npm install png-js



6、如不想用我的库，阻止主库更新后，当脚本报错缺少依赖时，依次执行以下3条命令，默认容器名jd_v4_bot，如做了修改，按实际修改命令。

  (前提scripts文件夹里得有package.json，没有就去我scripts库里找)

    docker exec -it jd_v4_bot bash
    
    cd scripts && npm install
    
