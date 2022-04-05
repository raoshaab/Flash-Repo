#! /usr/bin/env bash


#checking  If OS is Kali-Linux or other

o=$(grep "Kali GNU/Linux" /etc/os-release -o|wc -m)
if [[ "$o" == 0 ]] ; then echo This Script is for Kali-Linux OS && exit 1; fi

#get all mirror list for ip 
car='/tmp/fast-repo-dev'

mkdir $car 2>/dev/null && cd $car 2>/dev/null
curl -s http://http.kali.org/README.mirrorlist -k |grep "this country" -A 20|grep http|cut -d '/' -f3 > mirror
a=$(cat mirror)
echo ' Checking the Best Mirror ;)  Hold on '
echo -e '\n\n\n' 
#checking the mirror latency 
k=$(echo $a|wc -l)
for i in  $(cat mirror)
do
ping -c4 $i|grep rtt |cut -d '/' -f5 >>new 

  for((j=1; j<=k; j++))
   do
    echo -n "......."
   done
done

#combine result 
paste mirror new > final
repo=$(cat final|awk '{print NF, $0}' | sort -k1,1rn -k3 -n | cut -d' ' -f2-|head -n1|awk '{print $1}')

echo -e "\n\n\nNow we have Set best Mirror Repo to you Kali-Linux\n\n Try Now  sudo apt update    \n Happy Hacking :) @" 
 
sudo sed -i 's/^/#/g' "/etc/apt/sources.list"
echo "deb http://$repo/kali kali-rolling main contrib non-free" |sudo tee -a /etc/apt/sources.list >/dev/null 
sudo rm  -r $car 2>/dev/null
