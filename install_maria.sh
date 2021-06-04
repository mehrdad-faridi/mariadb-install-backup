#!/bin/bash

#title           :install_maria.sh
#description     :This script will install mariadb on the remote host.
#author          :Mehrdad Faridi
#date            :2021/27/May
#version         :0.8
#usage           :bash install_maria.sh
#notes           :Vim and Emacs are needed to use this script.
#bash_version    :4.4.20(1)-release
#===============================================================================
#------------------------------------
#Num  Colour    #define         R G B
#0    black     COLOR_BLACK     0,0,0
#1    red       COLOR_RED       1,0,0
#2    green     COLOR_GREEN     0,1,0
#3    yellow    COLOR_YELLOW    1,1,0
#4    blue      COLOR_BLUE      0,0,1
#5    magenta   COLOR_MAGENTA   1,0,1
#6    cyan      COLOR_CYAN      0,1,1
#7    white     COLOR_WHITE     1,1,1
#------------------------------------
black_color=`tput setaf 0`
red_color=`tput setaf 1`
green_color=`tput setaf 2`
yellow_color=`tput setaf 3`
blue_color=`tput setaf 4`
magenta_color=`tput setaf 5`
cyan_color=`tput setaf 6`
white_color=`tput setaf 7`
grey_color=`tput setaf 244`
default_color=`tput sgr0`


################################### variables
HOST_IP="<REMOTE_IP_ADDRESS>"
HOST_PORT="22"
HOST_USER="root"
MAARIA_PASS="mypass"
SCRIPT_DIR="/root/maria_backup"
CRONTAB_TIME="3 0 * * *"
TTY_BACKUP="3"
DB_USER="root"
DB_PASS="pass"

### full backup variable
FULL_BP_DIR="$SCRIPT_DIR/full-backup"
FULL_BP_SCRIPT_NAME="full_backup_maria.sh"
#FULL_DB_NAME="test"

### database backup variable
DB_BP_DIR="$SCRIPT_DIR/db-backup"
DATABASE_BP_SCRIPT_NAME="database_backup_maria.sh"
DATABASE_DB_NAME=(test1 test2 test3 test4 test5)

### table backup variable
TABLE_BP_DIR="$SCRIPT_DIR/table-backup"
TABLE_BP_SCRIPT_NAME="table_backup_maria.sh"
TABLE_DB_NAME="test"
TABLE_NAME=(test1 test2 test3)
###################################



# function for default menu
default_func(){
'clear'
echo -e "Please chooes one of the below numbers:$green_color\n\n[1] $white_color Intall mariadb 10.5:
$green_color[2] $white_color Create full backup:
$green_color[3] $white_color Create database(s) backup:
$green_color[4] $white_color Create table(s) backup:
$green_color[5] $white_color How long your backup will be exist$grey_color(default is: $TTY_BACKUP)$default_color:
$green_color[6] $white_color Show your input variables:
$green_color[7] $white_color Exit
$magenta_color--------------------------------"
read -p "$green_color Choose one of the above number:$default_color" MENU_NUMBER
	case $MENU_NUMBER in
		1)
			repo_func
			maria_install_func
		;;
		2)
			full_backup_func
		;;
		3)
			database_backup_func
		;;
		4)
			table_backup_func
		;;
		5)
			echo ""
			read -e -i "$TTY_BACKUP" -p " Please enter the number of days to remove old backup$grey_color(default is: $TTY_BACKUP)$default_color: " input
			TTY_BACKUP="${input:-$TTY_BACKUP}"

		;;
		6)
		clear
		echo -e "$cyan_color  ----------------------------------------------- "
		echo -e " |             Your  Variable is                 |"
		echo -e "  ----------------------------------------------- "
		echo -e "$green_color HOST_IP = $HOST_IP \n HOST_PORT = $HOST_PORT \n HOST_USER = $HOST_USER \n SCRIPT_DIR = $SCRIPT_DIR \n CRONTAB_TIME = $CRONTAB_TIME \n TTY_BACKUP = $TTY_BACKUP \n"
		sleep 5
		;;
		7|q)
			exit 0
		;;
		*)
		default_func
		;;
	esac
	return
}


#the below function is for add the mariadb 10.5 repo on centos 7.(we used the Frankfurt repo)
repo_func(){
ssh -Tq -p$HOST_PORT $HOST_USER@$HOST_IP << EOT
if [ ! -f "/etc/yum.repos.d/MariaDB.repo" ]
then
    echo "MariaDB.repo does not exist on your filesystem."
    sleep 2
sudo bash -c "cat >/etc/yum.repos.d/MariaDB.repo" <<"EOF"
# MariaDB 10.5 CentOS repository list - created 2021-05-27 13:18 UTC
# https://mariadb.org/download/
[mariadb]
name = MariaDB
baseurl = http://mirror.23media.de/mariadb/yum/10.5/centos7-amd64
gpgkey=http://mirror.23media.de/mariadb/yum/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF
fi
EOT

}


#Install the MariaDB server and client packages using yum, same as other CentOS package:
maria_install_func(){

ssh -Tq -p$HOST_PORT $HOST_USER@$HOST_IP << 'EOT'
if [[ `systemctl is-active mariadb` != "active" ]]
then
	sudo yum install MariaDB-server MariaDB-client -y -q
	sudo systemctl enable mariadb
	sudo systemctl start mariadb
	if [[ `systemctl is-active mariadb` == "active" ]]
	then
		echo -e "$blue_color mariadb is runing and active :)$default_color"
	else
   		echo -e "$red_color Unfortunatly, ther is a proble with mariadb$default_color"
   		sudo systemctl status mariadb
	exit 1
	fi

# expect install it using the following command:
	sudo mysql_secure_installation <<EOF

y
$MAARIA_PASS
$MAARIA_PASS
y
y
y
y
EOF
else
	echo -e "\n MAriaDB already is installed on remote host."
	sleep 2
fi

EOT
}

# the below function is for taking full backup of all the databases and tables
full_backup_func(){

ssh -Tq -p$HOST_PORT $HOST_USER@$HOST_IP << EOT
	if [[ -f "$SCRIPT_DIR/$FULL_BP_SCRIPT_NAME" ]]
	then
		sudo sed -i '/$FULL_BP_SCRIPT_NAME/d' /etc/crontab
		sudo bash -c "cat >>/etc/crontab" <<"EOF"
$CRONTAB_TIME root $SCRIPT_DIR/$FULL_BP_SCRIPT_NAME
EOF
		echo -e "\n$blue_color Shcedule job set for full backup.$default_color"
	else
		mkdir -p $FULL_BP_DIR
		sudo sed -i '/$FULL_BP_SCRIPT_NAME/d' /etc/crontab
		sudo bash -c "cat >>/etc/crontab" <<"EOF"
$CRONTAB_TIME root $SCRIPT_DIR/$FULL_BP_SCRIPT_NAME
EOF
		echo -e "\n$blue_color Shcedule job set for full backup.$default_color"
	fi
EOT
scp -P$HOST_PORT ${PWD}/$FULL_BP_SCRIPT_NAME $HOST_USER@$HOST_IP:$SCRIPT_DIR &> /dev/null
if [ $? -ne 0 ]; then
    echo "Error while transferring!"
else
    echo "Copy has been transferred successfully!"
ssh -Tq -p$HOST_PORT $HOST_USER@$HOST_IP << EOT
sudo chmod +x $SCRIPT_DIR/$FULL_BP_SCRIPT_NAME
sed -i 's/DB_USER=.*/DB_USER="$DB_USER"/' $SCRIPT_DIR/$FULL_BP_SCRIPT_NAME
sed -i 's/DB_PASS=.*/DB_PASS="$DB_PASS"/' $SCRIPT_DIR/$FULL_BP_SCRIPT_NAME
sed -i 's/TTY_BACKUP=.*/TTY_BACKUP="$TTY_BACKUP"/' $SCRIPT_DIR/$FULL_BP_SCRIPT_NAME
sed -i 's|SCRIPT_DIR=.*|SCRIPT_DIR="$SCRIPT_DIR"|' $SCRIPT_DIR/$FULL_BP_SCRIPT_NAME
sed -i 's|FULL_BP_DIR=.*|FULL_BP_DIR="$FULL_BP_DIR"|' $SCRIPT_DIR/$FULL_BP_SCRIPT_NAME
EOT
fi
}



# the below function get only backup from your database(s).
database_backup_func(){
ssh -Tq -p$HOST_PORT $HOST_USER@$HOST_IP << EOT
	if [[ -f "$SCRIPT_DIR/$DATABASE_BP_SCRIPT_NAME" ]]
	then
	        sudo sed -i '/$DATABASE_BP_SCRIPT_NAME/d' /etc/crontab
		sudo bash -c "cat >>/etc/crontab" <<"EOF"
$CRONTAB_TIME root $SCRIPT_DIR/$DATABASE_BP_SCRIPT_NAME
EOF
	        echo -e "\n$blue_color Shcedule job set for database backup.$default_color"
	else
	        mkdir -p $DB_BP_DIR
	        sudo sed -i '/$DATABASE_BP_SCRIPT_NAME/d' /etc/crontab
		sudo bash -c "cat >>/etc/crontab" <<"EOF"
$CRONTAB_TIME root $SCRIPT_DIR/$DATABASE_BP_SCRIPT_NAME
EOF
	        echo -e "\n$blue_color Shcedule job set for database backup.$default_color"
	fi
EOT
scp -P$HOST_PORT ${PWD}/$DATABASE_BP_SCRIPT_NAME $HOST_USER@$HOST_IP:$SCRIPT_DIR/ &> /dev/null
if [ $? -ne 0 ]; then
    echo "Error while transferring!"
else
    echo "Copy has been transferred successfully!"
ssh -Tq -i /home/mehrdad/Downloads/ultratendency_rsa -p$HOST_PORT $HOST_USER@$HOST_IP << EOT
sudo chmod +x $SCRIPT_DIR/$DATABASE_BP_SCRIPT_NAME
sed -i 's/DB_USER=.*/DB_USER="$DB_USER"/' $SCRIPT_DIR/$DATABASE_BP_SCRIPT_NAME
sed -i 's/DB_PASS=.*/DB_PASS="$DB_PASS"/' $SCRIPT_DIR/$DATABASE_BP_SCRIPT_NAME
sed -i 's/DATABASE_DB_NAME=.*/DATABASE_DB_NAME=($DATABASE_DB_NAME)/' $SCRIPT_DIR/$DATABASE_BP_SCRIPT_NAME
sed -i 's/TTY_BACKUP=.*/TTY_BACKUP="$TTY_BACKUP"/' $SCRIPT_DIR/$DATABASE_BP_SCRIPT_NAME
sed -i 's|SCRIPT_DIR=.*|SCRIPT_DIR="$SCRIPT_DIR"|' $SCRIPT_DIR/$DATABASE_BP_SCRIPT_NAME
sed -i 's|DB_BP_DIR=.*|DB_BP_DIR="$DB_BP_DIR"|' $SCRIPT_DIR/$DATABASE_BP_SCRIPT_NAME
EOT
fi

}



# the below function get only backup from specific table(s).
table_backup_func(){
ssh -Tq -p$HOST_PORT $HOST_USER@$HOST_IP << EOT
        if [[ -f "$SCRIPT_DIR/$TABLE_BP_SCRIPT_NAME" ]]
        then
                sudo sed -i '/$TABLE_BP_SCRIPT_NAME/d' /etc/crontab
		sudo bash -c "cat >>/etc/crontab" <<"EOF"
$CRONTAB_TIME root $SCRIPT_DIR/$TABLE_BP_SCRIPT_NAME
EOF
                echo -e "\n$blue_color Shcedule job set for table backup.$default_color"
        else
                mkdir -p $TABLE_BP_DIR
                sudo sed -i '/$TABLE_BP_SCRIPT_NAME/d' /etc/crontab
		sudo bash -c "cat >>/etc/crontab" <<"EOF"
$CRONTAB_TIME root $SCRIPT_DIR/$TABLE_BP_SCRIPT_NAME
EOF
                echo -e "\n$blue_color Shcedule job set for table backup.$default_color"
        fi
EOT
scp -P$HOST_PORT ${PWD}/$TABLE_BP_SCRIPT_NAME $HOST_USER@$HOST_IP:$SCRIPT_DIR/ &> /dev/null
if [ $? -ne 0 ]; then
    echo "Error while transferring!"
else
    echo "Copy has been transferred successfully!"
ssh -p$HOST_PORT $HOST_USER@$HOST_IP << EOT
sudo chmod +x $SCRIPT_DIR/$TABLE_BP_SCRIPT_NAME
sed -i 's/DB_USER=.*/DB_USER="$DB_USER"/' $SCRIPT_DIR/$TABLE_BP_SCRIPT_NAME
sed -i 's/DB_PASS=.*/DB_PASS="$DB_PASS"/' $SCRIPT_DIR/$TABLE_BP_SCRIPT_NAME
sed -i 's/TABLE_DB_NAME=.*/TABLE_DB_NAME="$TABLE_DB_NAME"/' $SCRIPT_DIR/$TABLE_BP_SCRIPT_NAME
sed -i 's/TABLE_NAME=.*/TABLE_NAME=($TABLE_NAME)/' $SCRIPT_DIR/$TABLE_BP_SCRIPT_NAME
sed -i 's/TTY_BACKUP=.*/TTY_BACKUP="$TTY_BACKUP"/' $SCRIPT_DIR/$TABLE_BP_SCRIPT_NAME
sed -i 's|SCRIPT_DIR=.*|SCRIPT_DIR="$SCRIPT_DIR"|' $SCRIPT_DIR/$TABLE_BP_SCRIPT_NAME
sed -i 's|TABLE_BP_DIR=.*|TABLE_BP_DIR="$TABLE_BP_DIR"|' $SCRIPT_DIR/$TABLE_BP_SCRIPT_NAME
EOT
fi

}

# run the menu
while true
do
   default_func
done
