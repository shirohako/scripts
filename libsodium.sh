#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	System Required: CentOS/Debian/Ubuntu
#	Description: libsodium Install
#	Version: 1.0.0
#	Author: ame
#=================================================

GreenPrefix="\033[42m" && RedPrefix="\033[41m" && BluePrefix="\033[44m" && Suffix="\033[0m"

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

echo -e "Do you want to install with Package Manager?"
read -e -p "(default: n):" yn

[[ -z ${yn} ]] && yn="n"
if [[ ${yn} == [Nn] ]]; then
	compilation_install
else
	package_manager_install
fi

package_manager_install(){
	if [[ $release == centos ]]; then
	    yum update
	    yum install epel-release -y
	    yum install libsodium -y
	else
	    apt-get update
	    apt-get install libsodium-dev
	fi
}

compilation_install(){
	if [[ $release == centos ]]; then
	    yum update
	    yum -y groupinstall "Development Tools"
	else
	    apt-get update
	    apt-get install -y build-essential
	fi

	LATEST_RELEASE=$(wget -qO- "https://github.com/jedisct1/libsodium/tags"|grep "/jedisct1/libsodium/releases/tag/"|head -1|sed -r 's/.*tag\/(.+)\">.*/\1/') 
	echo -e "${BluePrefix} Downloading libsodium ${LATEST_RELEASE} ${Suffix}"
	wget --no-check-certificate -N "https://github.com/jedisct1/libsodium/releases/latest/download/libsodium-${LATEST_RELEASE}.tar.gz"
	tar -xzf libsodium-${LATEST_RELEASE}.tar.gz && cd libsodium-${LATEST_RELEASE}

	echo -e "${BluePrefix} Compiling ${Suffix}"
	./configure --disable-maintainer-mode && make -j2 && make install
	ldconfig

	if [[ -e "/usr/local/lib/libsodium.so" ]]; then
		echo -e "${GreenPrefix}Installation successful!${Suffix}"
		cd .. && rm -f libsodium-${LATEST_RELEASE}.tar.gz && rm -rf libsodium-${LATEST_RELEASE}
	else
		echo -e "${RedPrefix}Installation has failed!${Suffix}"
	fi
}

