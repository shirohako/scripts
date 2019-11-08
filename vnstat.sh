if [[ $EUID != 0 ]]; then echo -e "\nNaive! I think this young man will not be able to run this script without root privileges.\n" ; exit 1 ; fi

read -p "Centos or Ubuntu(Default)? [c/u]" release
case $release in
        [cC] ) os=centos;;
        * ) os=ubuntu;;
esac


if [[ $os == ubuntu ]]; then
        apt-get wget install make gcc libc6-dev wget libsqlite3-0 libsqlite3-dev ntpdate -y
else
    	yum install wget sqlite-devel nano gcc ntpdate gd-devel -y
    	yum install kernel-headers -y
fi

cp /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
ntpdate asia.pool.ntp.org

wget https://humdi.net/vnstat/vnstat-latest.tar.gz
tar zxvf vnstat-latest.tar.gz
rm vnstat-latest.tar.gz -f
cd vnstat-2*
./configure --prefix=/usr --sysconfdir=/etc && make && make install

wget https://raw.githubusercontent.com/vergoh/vnstat/master/examples/systemd/simple/vnstat.service

chmod 754 vnstat.service && mv vnstat.service /etc/systemd/system -f
systemctl enable vnstat && systemctl start vnstat
systemctl daemon-reload
