## 重要通知
### 落日与孤鹜齐飞,秋水共长天一色。
收集全网目前能正常使用的脚本。


【Faker3集合仓库】
``` 
ql repo https://ghproxy.com/https://github.com/buqian123/faker3.git "jd_|jx_|gua_|jddj_|getJDCookie" "activity|backUp" "^jd[^_]|USER|function|utils|sendnotify|ZooFaker_Necklace.js|JDJRValidator_|sign_graphics_validate|ql"
```
```

【青龙系列教程】
https://www.notion.so/Cent-OS-7-6-1c598629675145988b43a37998a1604a





## 安装docker 安装2.9.3青龙 配置Faker3仓库，与青蛙开卡仓库

本命令安装青龙2.9.3版本镜像

```jsx
wget -q https://raw.githubusercontents.com/shufflewzc/VIP/main/Scripts/sh/ql.sh -O ql.sh && bash ql.sh
```

## NvJdc一键配置

```bash
bash <(curl -sL https://ghproxy.com/https://raw.githubusercontent.com/shufflewzc/normal-shell/main/onekey-install-nvjdc.sh)
```

## 已安装青龙的用户一键配置代码 配置Faker3仓库助力

```jsx
docker exec -it qinglong bash -c "$(curl -fsSL https://ghproxy.com/https://github.com/shufflewzc/VIP/blob/main/Scripts/sh/1customCDN.sh)"
```



#### 说明



* 想跑gua开卡的可以加,false改成true
    ```
    export guaopencard_All="false"
    export guaopencard_addSku_All="false"
    export guaopencardRun_All="false"
    export guaopencard_draw="false"
    ```


 - 更新一个整库脚本
 ```
 ql repo <repourl> <path> <blacklist> <dependence> <branch>
 ```
 - 更新单个脚本文件
 ```
 ql raw <fileurl>
 ```


### 安装青龙需要一些的依赖
<details>
<summary>查看依赖列表</summary>


* 最新青龙支持安装依赖需要啥依赖，去依赖管理添加即可，简单方便
* 遇到Cannot find module 'xxxxxx'报错就进入青龙容器
* docker exec -it QL(自己容器名) bash
* pnpm install xxxxx(报错中引号里的复制过来)

 

 安装青龙的一些依赖，按需求安装
* docker exec -it qinglong(自己容器名) bash -c "npm install -g typescript"

* docker exec -it qinglong bash -c "npm install axios date-fns"

* docker exec -it qinglong bash -c "npm install crypto -g"

* docker exec -it qinglong bash -c "npm install png-js"

* docker exec -it qinglong bash -c "npm install -g npm"

* docker exec -it qinglong bash -c "pnpm i png-js"

* docker exec -it qinglong bash -c "pip3 install requests"

* docker exec -it qinglong bash -c "apk add --no-cache build-base g++ cairo-dev pango-dev giflib-dev && cd scripts && npm install canvas --build-from-source"

* docker exec -it qinglong bash -c "apk add python3 zlib-dev gcc jpeg-dev python3-dev musl-dev freetype-dev"

* docker exec -it qinglong bash -c "cd /ql/scripts/ && apk add --no-cache build-base g++ cairo-dev pango-dev giflib-dev && npm i && npm i -S ts-node typescript @types/node date-fns axios png-js canvas --build-from-source"

或者

* npm install -g png-js
* npm install -g date-fns
* npm install -g axios
* npm install -g crypto-js
* npm install -g ts-md5
* npm install -g tslib
* npm install -g @types/node
* npm install -g requests

</details>








