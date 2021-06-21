wget -c https://raw.githubusercontent.com/Annyoo2021/jd_v4_bot/main/v4mb.tar.gz
tar -zxvf v4mb.tar.gz
rm -f v4mb.tar.gz
cp -r v4mb config/
cp -r v4mb/panel panel
cp v4mb/20-jup /etc/cont-init.d/20-jup
cp v4mb/jshare.sh /jd/jshare.sh
cp v4mb/config/diy.sh config/diy.sh
rm -rf v4mb
cd panel
pm2 start server.js
ln -s /jd/config/v4mb/25-server /etc/cont-init.d/25-server
echo -e "面板已更新完成，请使用旧密码进行访问面板"
