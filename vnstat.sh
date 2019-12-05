#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	System Required: CentOS/Debian/Ubuntu
#	Description: vnStat Install
#	Version: 1.0.0
#	Author: ame
#=================================================

GreenPrefix="\033[42m" && RedPrefix="\033[41m" && BluePrefix="\033[44m" && Suffix="\033[0m"


if [[ $EUID != 0 ]]; then echo -e "\nNaive! I think this young man will not be able to run this script without root privileges.\n" ; exit 1 ; fi

if [[ -f /etc/redhat-release ]]; then
        release="centos"
elif cat /etc/issue | grep -q -E -i "debian"; then
        release="debian"
elif cat /etc/issue | grep -q -E -i "ubuntu"; then
        release="ubuntu"
elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
        release="centos"
elif cat /proc/version | grep -q -E -i "debian"; then
        release="debian"
elif cat /proc/version | grep -q -E -i "ubuntu"; then
        release="ubuntu"
elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
        release="centos"
fi

if [[ $release == centos ]]; then
    yum install wget sqlite-devel nano gcc ntpdate gd-devel -y
    yum install kernel-headers -y
else
    apt-get install wget make gcc libc6-dev libgd-dev libsqlite3-0 libsqlite3-dev ntpdate -y
fi

<<<<<<< HEAD
wget -N --no-check-certificate https://humdi.net/vnstat/vnstat-latest.tar.gz
=======
wget -N https://humdi.net/vnstat/vnstat-latest.tar.gz
>>>>>>> 69344326470f018d3430f25f299def3d22ea0390
tar zxvf vnstat-latest.tar.gz
rm vnstat-latest.tar.gz -f
cd vnstat-2*
./configure --prefix=/usr --sysconfdir=/etc && make && make install

if [[ ! -f /usr/bin/vnstat ]]; then
<<<<<<< HEAD
   echo -e "${RedPrefix}Installation has failed!${Suffix}"
   exit 1
fi

cp /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
ntpdate asia.pool.ntp.org

wget -N --no-check-certificate https://raw.githubusercontent.com/vergoh/vnstat/master/examples/systemd/simple/vnstat.service
=======
   echo "安装失败!"
   exit 1
fi

cp /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
ntpdate asia.pool.ntp.org

wget https://raw.githubusercontent.com/vergoh/vnstat/master/examples/systemd/simple/vnstat.service
>>>>>>> 69344326470f018d3430f25f299def3d22ea0390
chmod 754 vnstat.service && mv vnstat.service /etc/systemd/system -f
systemctl enable vnstat && systemctl start vnstat
systemctl daemon-reload

cd .. && rm -rf vnstat-2*

echo -e "${GreenPrefix}Installation successful!${Suffix}"