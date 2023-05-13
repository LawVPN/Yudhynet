#!/bin/bash

dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`

############# LawNET #############
#Text Coloring
clear
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
tyblue='\e[1;36m'
NC='\e[0m'
purple() { echo -e "\\033[35;1m${*}\\033[0m"; }
tyblue() { echo -e "\\033[36;1m${*}\\033[0m"; }
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
############# LawNET #############

#System version number
cd
if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi

localip=$(hostname -I | cut -d\  -f1)
hst=( `hostname` )
dart=$(cat /etc/hosts | grep -w `hostname` | awk '{print $2}')
if [[ "$hst" != "$dart" ]]; then
echo "$localip $(hostname)" >> /etc/hosts
fi
mkdir -p /etc/xray

clear
echo -e "[ ${tyblue}NOTES${NC} ] AUTO INSTALL SCRIPT.... "
sleep 1
echo -e "[ ${tyblue}NOTES${NC} ] Multi path, Multi port, support debian 10 , Ubuntu 20-18"
sleep 2
echo -e "[ ${green}INFO${NC} ] By LawNET"
sleep 1
echo -e "[ ${green}INFO${NC} ] t.me/law_sky"
sleep 5

secs_to_human() {
    echo "Installation time : $(( ${1} / 3600 )) hours $(( (${1} / 60) % 60 )) minute's $(( ${1} % 60 )) seconds"
}
start=$(date +%s)
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null 2>&1
sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null 2>&1

coreselect=''
cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
clear
END

chmod 644 /root/.profile

echo -e "[ ${green}INFO${NC} ] Preparing the install file 🛠"
apt install git curl -y >/dev/null 2>&1
echo -e "[ ${green}INFO${NC} ] Alright good ... installation file is ready 📡"
sleep 2
echo -ne "[ ${green}INFO${NC} ] Check permission : success 😁"
sleep 3
mkdir -p /etc/yudhynetwork
mkdir -p /etc/yudhynetwork/theme
mkdir -p /var/lib/yudhynetwork-pro >/dev/null 2>&1
echo "IP=" >> /var/lib/yudhynetwork-pro/ipvps.conf

if [ -f "/etc/xray/domain" ]; then
echo ""
echo -e "[ ${green}INFO${NC} ] Script Already Installed"
echo -ne "[ ${yell}WARNING${NC} ] Do you want to install again ? (y/n)? "
read answer
if [ "$answer" == "${answer#[Yy]}" ] ;then
rm setup.sh
sleep 10
exit 0
else
clear
fi
fi

echo ""
wget -q https://raw.githubusercontent.com/LawVPN/main/data/dependencies.sh;chmod +x dependencies.sh;./dependencies.sh
rm dependencies.sh
clear

yellow "Add Your Domain"
echo " "
read -rp "Input your domain : " -e pp
echo "$pp" > /root/domain
echo "$pp" > /root/scdomain
echo "$pp" > /etc/xray/domain
echo "$pp" > /etc/xray/scdomain
echo "IP=$pp" > /var/lib/yudhynetwork-pro/ipvps.conf

