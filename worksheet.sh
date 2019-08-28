#!/bin/bash

while :
do
BLUE='\033[1;36m'
NC='\033[0m'
echo -e "${BLUE}============Main Menu============${NC}"
echo -e "\t(1)Network Monitoring "
echo -e "\t(2)Google Search "
echo -e "\t(3)Open Google Docs and Search a word"
echo -e "\t(4)User Functions "
echo -e "\t(5)File Transfer "
echo -e "\t(6)Cache clearence "
echo -e "\t(7)Want to have fun?"
echo -e "\t(8)Exit "
echo -n "Please enter your choice:"
read choice
case $choice in
    "1")
    while :
    do
    echo -e "\t(1)Get me IP Address"
    echo -e "\t(2)Check Internet Connection"
    echo -e "\t(3)Check Servers"
    echo -e "\t(4)List all valid IP Addresses in the network"
    echo -e "\t(5)Open Network Settings"
    echo -e "\t(6)Speed Test"
    echo -e "\t(7)Return to main menu"
    echo -n "Please enter your choice:"
    read choice1
    case $choice1 in
        "1")
         BLUE='\033[1;36m'
         NC='\033[0m'
         IP=$(hostname -I)
         echo -e "${BLUE}>>>>>>>$IP<<<<<<<${NC}"
         ;;

        "2")
         echo " Network connection "
         ./network.sh
         ;;

        "3")
         ./servers.sh
         ;;

        "4")
         nmap -sn 192.168.1.1/24
         ;;
         
        "5")
         nm-connection-editor
         ;;
         
        "6")
         google-chrome --new-window www.speedtest.net
         xdotool mousemove 632 512
         sleep 3
         xdotool click 1
         sleep 44
         xdotool key Alt+F4
         ;;
         
        "7")
         break
         ;;
            *)
            echo "invalid answer, please try again"
            ;;
    esac
    done
    clear
    ;;
      
      "2")
       #Googel search
       read -p "Enter Your Search Term: "  searchterm 
       xdg-open "http://www.google.com/search?q=$searchterm"
       clear
       ;; 
      "3")
       #Google docs
       read -p "Enter Your Search Term: "  searchterm2
       google-chrome https://docs.google.com/document/d/1mN6js0OtdXV0IRKuWf8iMJNWBbN1uidKItFxelLaX0c/edit
       sleep 4
       xdotool key caps
       xdotool key ctrl+h
       xdotool type $searchterm2
       xdotool key KP_Enter
       ;;
      "4")
      #user functions
       while : 
       do
         
         echo -e "\t(1)Create a User"
         echo -e "\t(2)Delete a User"
         echo -e "\t(3)Create a File"
         echo -e "\t(4)Delete a File"
         echo -e "\t(5)Create a Directory"
         echo -e "\t(6)Delete a Directory"
         echo -e "\t(7)Show Files Sizes in Disk"
         echo -e "\t(8)Backup a Folder"
         echo -e "\t(9)SSH Login"
         echo -e "\t(10)Return to Main Menu"
         echo -n "Please enter your chioce: "      
         read choice2
         case $choice2 in
          "1")
             #User creation
             if [ $(id -u) -eq 0 ]; then
                read -p "Enter username : " username
                read -s -p "Enter password : " password
                egrep "^$username" /etc/passwd >/dev/null
            if [ $? -eq 0 ]; then
                echo "$username exists!"
                exit 1
            else
                pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
                useradd -m -p $pass $username
                [ $? -eq 0 ] && echo "\nUser has been added to system!" || echo "Failed to add a user!"
            fi
            else
                echo -e "Only root may add a user to the system"
                exit 2
            fi
            ;;

          "2")
            #User Delete
            if [ $(id -u) -eq 0 ]; then
                    read -p " Enter the username you want to delete: " username
                    userdel  $username
            else
                echo -e "Only root may delete a user in the system"
                exit 2
            fi
            ;;

          "3")
            #File creation
            read -p " Enter filename: " Filename
            touch $Filename
            echo -e " File created under path $(readlink -f $Filename) "
            ;;

          "4")
            #File Delete
            read -p " Enter filename to delete: " deletefile
            rm -rf $deletefile
            echo -e " $deletefile is deleted "
            ;;
 
          "5") 
            #Directory creation
            read -p " Enter Directory name: " Directoryname
            mkdir -m a=rwx $Directoryname
            echo -e " Directory Created under path $(readlink -f $Directoryname) "
            ;;

          "6")
            #Delete Directory
            read -p " Enter a directoy name to delete: " deletedir
            rm -rf $deletedir
            echo -e " $deletedir is deleted "
            ;;
          "7")
          # Diskfiles
            sudo apt-get install ncdu -y 
            ncdu
            ;;
 
          "8")
            #Backup a folder
            read -p " Enter Source path: " Sourcefolder
            read -p " Enter Destination path: " Destinationfolder
            BACKUPTIME=`date +%b-%d-%y` #get the current date
            DESTINATION=$Destinationfolder-$BACKUPTIME.tar.gz #create a backup file using the current date in it's name
            SOURCEFOLDER=$Sourcefolder #the folder that contains the files that we want to backup
            tar -cpzf -C $DESTINATION $SOURCEFOLDER #create the backup   
            ;;
          
          "9")
           #ssh login
           echo "=====SSH Login====="
           read -p "Enter Your Username on server: "  serverusername
           read -p "Enter IP Address/Hostname of server: " serverip
           ssh -X $serverusername@$serverip
           ;;

         "10")
          break
          ;;
             *)
             echo "invalid answer, please try again"
             ;;
     esac
     done
     clear
     ;; 
     "5")
     while :
     do
      
      echo -e "\t(1)Send file from Server to Local Machine (DOWNLOAD)"
      echo -e "\t(2)Send file from Local Machine to Server (UPLOAD)"
      echo -e "\t(3)Return to Main Menu"
      echo -n "Please Enter Your Choice:"
     read choice3
     case $choice3 in
       "1")
         read -p " Enter full path of file/folder you want to send: " sourcepath1
            read -p " Enter your username of server: " username
            read -p " Enter Server Ip Address: " serverip
            read -p " Enter full path of file/folder you want to store in: " destinationpath

            if scp $username@$serverip:$sourcepath $destinationpath ; then
            echo " =====File/Folder Transfer successfully completed===== "
            else
            echo " =====Errors encountered===== "
            fi
            ;;

       "2")
            read -p " Enter full path of file/folder you want to send: " sourcepath
            read -p " Enter your username of server: " username
            read -p " Enter Server Ip Address: " serverip
            read -p " Enter full path of file/folder you want to store in: " destinationpath

            if scp $sourcepath $username@$serverip:$destinationpath; then
            echo " =====File/Folder Transfer successfully completed===== "
            else
            echo " =====Errors encountered===== "
            fi
            ;;

       "3")
            break
            ;;
             *)
             echo "invaild answer, please try again"
             ;;
       esac
       done
       clear
       ;;
       "6")
        while :
        do 
         
         echo -e "\t(1)Clean DNS Cache"
         echo -e "\t(2)Clean System Cache"
         echo -e "\t(3)Clear RAM Cache"
         echo -e "\t(4)Return to Main Menu"
         echo -n "Please Enter Your Choice: "
         read choice4
         case $choice4 in 
         
         "1")
         #Dns cache      
         echo -e "Your DNS cache will be cleaned in seconds"
         sudo /etc/init.d/dns-clean restart
         sudo /etc/init.d/networking force-reload
         sudo service network-manager restart
         RED='\033[0;32m'
         NC='\033[0m'
         echo -e " ${RED}DNS Cache clearance is used to get rid of\n'Site can't be reached' error  when visiting a web page..${NC} "
         echo -e " ${RED}                   DNS CACHE CLEARED${NC} "
         ;;

         "2")
         RED='\033[0;32m'
         NC='\033[0m'
         echo -e "${RED}==========Your System cache from packages that are no longer in use will be cleared=========${NC}"
         sudo apt-get autoclean -y
         sudo apt-get autoremove -y
         ;;

        "3") 
         BLUE='\033[1;36m'
         NC='\033[0m'
         free -m 
         echo -e "${BLUE}================Check if free space of RAM incresed==============${NC}"
         sync && sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'
         sync && sudo sh -c 'echo 2 > /proc/sys/vm/drop_caches'
         sync && sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'
         free -m
         ;;

        "4")
          break
          ;;
            *)
            echo "invalid answer, please try again"
             ;;
         esac
         done
         clear
         ;;
         
         #Twitter status update
         #url -u YourUsername:YourPassword -d status="Your status message" http://twitter.com/statuses/update.xml
         #Weather
         #curl wttr.in  -for current place
         #curl wttr.in/chennai  -for specific place
     
         #sudo apt-get install bb && bb
         #sudo apt-get install sl && sl
                 
         #sudo apt-get install oneko && oneko
         #sudo apt-get install xeyes && xeyes
    

         "7")
         while :
         do
         echo -e "\t(1)Be Ethan Hunt for sometime"           
         echo -e "\t(2)Work with secret service"
         echo -e "\t(3)See what i have for you"
         echo -e "\t(4)Return to Main Menu"
         echo -n "Please enter your chioce: "
         read choice5
         case $choice5 in
            #fun mode 
            "1")
            GREEN='\033[0;32m'
            YELLOW='\033[0;34m'
            NC='\033[0m'
            echo -e "${GREEN}==============WELCOME MR.HUNT===============\n=============GOOD TO HAVE YOU BACK==============\nYour request on password breaking is in processing"
            echo -e "To Exit  Hacking Press ctrl+c(2 times)\nand Type exit\n============Turn Up The Volume Please===========${NC}"
            read -p "============PRESS ENTER TO START HACKING============"
            hollywood
            ;;
 
          "2")
          GREEN='\033[0;32m'
          NC='\033[0m'
          echo -e "${GREEN}You're about to visit a webpage that looks like you're hacking something\nAfter visiting the webpage${NC}"
          echo -e "${GREEN}Start typing randomly${NC}"
          read -p "Press enter to start"
          search=https://geekprank.com/hacker/
          google-chrome "$search"
          ;;
 
          "3")
          BLUE='\033[1;36m'
          NC='\033[0m'
          echo -e "${BLUE} Hello Sans, ....$(fortune)${NC}" | pv -qL 18
          ;;
          
          #Twitter status update
          #url -u YourUsername:YourPassword -d status="Your status message" http://twitter.com/statuses/update.xml
          #Weather
          #curl wttr.in  -for current place
          #curl wttr.in/madurai  -for specific place
          #sudo apt-get install bb && bb
          #sudo apt-get install sl && sl
          #sudo apt-get install oneko && oneko
          #sudo apt-get install xeyes && xeyes
          



          "4")
          break
          ;;
            *)
             echo "invalid answer, please try again"
             ;;
          esac
          done
          clear
          ;;
          "8")
          echo -e "Bye!"
          exit
          ;;
            *)
          echo "invalid answer, please try again"
          ;;
          esac
          done
