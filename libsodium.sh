#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	System Required: CentOS/Debian/Ubuntu
#	Description: libsodium Install
#	Version: 1.0.0
#	Author: ame
#=================================================


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
	yum update
    yum -y groupinstall "Development Tools"
else
	apt-get update
    apt-get install -y build-essential
fi

GreenPrefix="\033[42m" && RedPrefix="\033[41m" && BluePrefix="\033[44m" && Suffix="\033[0m"

LATEST_RELEASE=$(wget -qO- "https://github.com/jedisct1/libsodium/tags"|grep "/jedisct1/libsodium/releases/tag/"|head -1|sed -r 's/.*tag\/(.+)\">.*/\1/') 

echo -e "${BluePrefix}Downloading libsodium ${LATEST_RELEASE} ${Suffix}"

wget --no-check-certificate "https://github.com/jedisct1/libsodium/archive/${LATEST_RELEASE}.tar.gz"

tar -xzf ${LATEST_RELEASE}.tar.gz && cd libsodium-${LATEST_RELEASE}
./configure --disable-maintainer-mode && make -j2 && make install
ldconfig
cd .. && rm -rf ${LATEST_RELEASE}.tar.gz && rm -rf libsodium-${LATEST_RELEASE}

echo -e "${GreenPrefix}Installation successful!${Suffix}"