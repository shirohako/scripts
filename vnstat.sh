#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	System Required: CentOS/Debian/Ubuntu
#	Description: vnStat Install
#	Version: 1.0.0
#	Author: ame
#=================================================


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
    apt-get wget install make gcc libc6-dev wget libsqlite3-0 libsqlite3-dev ntpdate -y
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
