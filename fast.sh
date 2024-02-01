#! /usr/bin/env bash
#author: github.com/raoshaab


#functions 
function kali(){
    current_dir='/tmp/fast-repo-dev'
    mkdir $current_dir 2>/dev/null 
    cd $current_dir 2>/dev/null
    
    #Get the mirror
    mirror=$(curl -s http://http.kali.org/README?mirrorlist |grep    '<td style="text-align: right;"><a href="'|egrep 'http://.+$' -o|cut -d '"' -f1|sed 's/README//g'|head  -n1)
    
    echo -e  '\e[32mChecking the Best Mirror ;)  Hold on ヽ(´▽`)/.......  \e[0m'
    echo -e '\n\n\n' 

   #Note: Speed Checking function removed, As all the mirrors are already Checked and in order

    
    sudo sed -i 's/^/#/g' "/etc/apt/sources.list"
    echo "deb $mirror kali-rolling main contrib non-free" |sudo tee -a /etc/apt/sources.list >/dev/null 
    echo -e "\n\n\n \e[93mFast Mirror Repo set\n\n \e[96mTry Now with \e[91msudo apt update    \n\e[95m @raoshaab :)"
    sudo rm  -r $current_dir 2>/dev/null
    sudo wget -q http://archive.kali.org/archive-key.asc -O /etc/apt/trusted.gpg.d/kali-archive-keyring.asc 
    
}

function ubuntu(){
    current_dir='/tmp/fast-repo-dev'
    mkdir $current_dir 2>/dev/null 
    cd $current_dir 2>/dev/null
    
    #Get the mirror
    curl -sL http://mirrors.ubuntu.com/mirrors.txt > mirrors
    mirror=$(curl -sL http://mirrors.ubuntu.com/mirrors.txt|cut -d'/' -f3  )
    echo -e  '\e[32mChecking the Best Mirror ;)  Hold on ヽ(´▽`).......  \e[0m'
    echo -e '\n\n\n' 
    

    #checking the mirror latency 
    for i in  $(echo $mirror)
    do
    echo $(ping -c4 -w5 $i|grep rtt |cut -d '/' -f5)   $i  >> new 
    done
    wait

    #get repo 
    
    repo=$(cat new|grep -e [0-9]|sort -n|head -n1|awk '{print $2}' ) 
    fast_server=$(cat mirrors|grep $repo|head -n1) 
    
    #setting the mirror /etc/apt/sources.list
    
    code=$(lsb_release -c|awk '{print $2}')
    sudo sed -i 's/^/#/g' "/etc/apt/sources.list"

    echo "deb $fast_server $code main restricted " |sudo tee -a /etc/apt/sources.list >/dev/null 
    echo "deb $fast_server $code-updates main restricted " |sudo tee -a /etc/apt/sources.list >/dev/null 
    echo "deb $fast_server $code multiverse" |sudo tee -a /etc/apt/sources.list >/dev/null 
    echo "deb $fast_server $code-updates multiverse" |sudo tee -a /etc/apt/sources.list >/dev/null 

    echo -e "\n\n\n \e[93mFast Mirror Repo set\n\n \e[96mTry Now with \e[91msudo apt update    \n\e[95m @raoshaab :)"


    #Cleaning Up 
    sudo rm  -r $current_dir 2>/dev/null
    
}




echo -e "\e[3$(( $RANDOM * 6 / 32767 + 1 ))m"

bann="  
  ____   _                 _                                            
 / ___| | |               | |                                            
| |_    | |   __ _   ___  | |__    ______   _ ___    ___    _ __      ___  
|  _|   | |  / _  | / __| | '_ \  |__==__| | |_|_|  / _ \  | '_  \   / _ \ 
| |     | | | (_| | \__ \ | | | |          | |     |  __/  | | _) | | (_) |
|_|     |_|  \__'_| |___/ |_| |_|          |_|      \___|  | |___/   \___/ 
                                                           | |             
                                                           |_|            "

while IFS= read -r -n 1 -d '' c; do   printf '\e[38;5;%dm%s\e[0m'  "$((RANDOM%255+1))" "$c"; done <<<$bann

#checking for root access 
user=$(whoami)
if [[ $user == "root"  ]]
then 
    echo ' '
else 
    echo -e '\n\n\t\t\t\t \e[91mRun with sudo!!' && exit 1
fi

#checking  If OS is Kali-Linux or Ubuntu
os=$(cat /etc/os-release|grep "^ID="|cut -d '=' -f2)

if [ $os == "kali" ]
then 
    kali
elif [ $os == "ubuntu" ]
then 
    ubuntu
else    
    echo "OS not supported " && exit 1
fi
