#依次运行以下命令，安装jd_v4_bot和面板。


1、安装v4_bot(amd64) 一键命令（1）

  (提前在宿主机新建文件夹jd_v4_bot，下面再新建config，log，own，diy，scripts五个文件夹。如要自行修改路径，记得为绝对路径。)
  
    docker run -dit \
      -v /jd_v4_bot/config:/jd/config \
      -v /jd_v4_bot/log:/jd/log \
      -v /jd_v4_bot/own:/jd/own \
      -v /jd_v4_bot/diy:/jd/jbot/diy \
      -v /jd_v4_bot/scripts:/jd/scripts \
      -p 5678:5678 \
      -e ENABLE_HANGUP=true \
      -e ENABLE_WEB_PANEL=true \
      -e ENABLE_WEB_TTYD=true \
      --name jd_v4_bot \
      --hostname jd_v4_bot \
      --restart always \
      annyooo/jd:v4_bot



1.1、安装v4_bot(amd64) 一键命令（2）

    wget -q https://raw.githubusercontent.com/Annyoo2021/jd_v4_bot/main/jd-docker.sh -O jd-docker.sh && chmod +x jd-docker.sh && ./jd-docker.sh


   
2、进入容器，默认容器名jd_v4_bot，如做了修改，按实际修改命令。

    docker exec -it jd_v4_bot bash 


 
3、此面板集成了ttyd，不要安装，待修改。
安装面板 (切记先要进入容器再执行)，执行以下命令后，请访问5678端口进行配置，如果你做了修改或映射，请使用实际端口进行访问，默认用户名admin，密码adminadmin。
 
    wget -q https://raw.githubusercontent.com/Annyoo2021/jd_v4_bot/main/v4mb.sh -O v4mb.sh && chmod +x v4mb.sh && ./v4mb.sh
 
 

3.1、此面板集成了ttyd，不要安装，待修改。
更新或重装面板 (切记先要进入容器再执行)，执行以下命令后，请使用旧密码进行访问面板。

    wget -q https://raw.githubusercontent.com/Annyoo2021/jd_v4_bot/main/v4mb_up.sh -O v4mb_up.sh && chmod +x v4mb_up.sh && ./v4mb_up.sh



4、镜像默认用我的库作为主库，三方库自行添加。装好更新后，安装新版宠汪汪的依赖：

 （先进入容器，参考第2条。再依次执行以下3条命令。）

    apk add --no-cache build-base g++ cairo-dev pango-dev giflib-dev

    cd scripts

    npm install canvas --build-from-source



5、如不想用我的库，阻止主库更新后，当脚本报错缺少依赖时，依次执行以下3条命令，默认容器名jd_v4_bot，如做了修改，按实际修改命令。

  (前提scripts文件夹里得有package.json，没有就去上面scripts.tar.gz里找)

    docker exec -it jd_v4_bot bash
    cd scripts
    npm install
