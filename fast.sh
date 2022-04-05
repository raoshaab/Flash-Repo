#! /usr/bin/env bash


#banner

echo -e "\e[31m "   
printf "   __   _  \n"            _                                            
printf "  / _| | |               | |                                           \n"
printf " | |_  | |   __ _   ___  | |__    ______   _ __    ___   _ __     ___  \n"
printf " |  _| | |  / _  | / __| | '_ \  |______| | '__|  / _ \ | '_ \   / _ \ \n"
printf " | |   | | | (_| | \__ \ | | | |          | |    |  __/ | |_) | | (_) |\n"
printf " |_|   |_|  \__'_| |___/ |_| |_|          |_|     \___| | .__/   \___/ \n"
printf "                                                        | |            \n"
printf "                                                        |_|            \n"
echo -e "\e[0m"

#checking  If OS is Kali-Linux or other

o=$(grep "Kali GNU/Linux" /etc/os-release -o|wc -m)
if [[ "$o" == 0 ]] ; then echo This Script is for Kali-Linux OS && exit 1; fi

#get all mirror list for ip 
car='/tmp/fast-repo-dev'

mkdir $car 2>/dev/null && cd $car 2>/dev/null
curl -s http://http.kali.org/README.mirrorlist -k |grep "this country" -A 20|grep http|cut -d '/' -f3 > mirror
a=$(cat mirror)
echo -e  '\e[32m Checking the Best Mirror ;)  Hold on ヽ(´▽`)/  \e[0m'
echo -e '\n\n\n' 
#checking the mirror latency 
k=$(echo $a|wc -l)

for i in  $(cat mirror)
do
ping -c4 $i|grep rtt |cut -d '/' -f5 >>new 
echo -n "......."
done

#combine result 

paste mirror new > final
repo=$(cat final|awk '{print NF, $0}' | sort -k1,1rn -k3 -n | cut -d' ' -f2-|head -n1|awk '{print $1}')

echo -e "\n\n\n \e[96m  Now we have Set best Mirror Repo to you Kali-Linux \n\n Try Now  sudo apt update    \n Happy Hacking :) @raoshaab" 
 
sudo sed -i 's/^/#/g' "/etc/apt/sources.list"
echo "deb http://$repo/kali kali-rolling main contrib non-free" |sudo tee -a /etc/apt/sources.list >/dev/null 
sudo rm  -r $car 2>/dev/null
