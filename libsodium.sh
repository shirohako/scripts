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

LATEST_RELEASE=$(wget -qO- "https://github.com/jedisct1/libsodium/tags"|grep "/jedisct1/libsodium/releases/tag/"|head -1|sed -r 's/.*tag\/(.+)\">.*/\1/') 

echo -e "${BluePrefix}Downloading libsodium latest release:${LATEST_RELEASE}${Suffix}"

wget --no-check-certificate -N "https://github.com/jedisct1/libsodium/archive/${LATEST_RELEASE}.tar.gz"

tar -xzf ${LATEST_RELEASE}.tar.gz && cd libsodium-${LATEST_RELEASE}
./configure --disable-maintainer-mode && make -j2 && make install
ldconfig
cd .. && rm -rf ${LATEST_RELEASE}.tar.gz && rm -rf libsodium-${LATEST_RELEASE}

echo -e "${GreenPrefix}Installation successful!${Suffix}"