#!/bin/bash

#title           :database_backup_maria.sh
#description     :This script will create backup of your database(s) define from MariaDB.
#author          :Mehrdad Faridi
#date            :2021/27/May
#version         :0.5
#usage           :bash database_backup_maria.sh
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
SCRIPT_DIR="/root/maria_backup"
DB_BP_DIR="/root/maria_backup/db-backup"
LOG_DIR="/var/log/mybackup-mariadb.log"
DB_USER="ROOT"
DB_PASS="pass"
DATABASE_DB_NAME=(test1 test2 test3 test4 test5)
TTY_BACKUP="5"

###################################


touch $LOG_DIR

#get length of lists
db_length=${#DATABASE_DB_NAME[@]}
i=0
while [ $i -lt $db_length ]
do
echo -e "######################################## Create ${DATABASE_DB_NAME[$i]} Database backup `date '+%Y-%m-%d__%H:%M:%S'` ########################################" >> $LOG_DIR
echo -e "$yellow_color Creating database: ${DATABASE_DB_NAME[$i]} backup starting, Please wait...$default_color"
mysqldump -u $DB_USER -p$DB_PASS ${DATABASE_DB_NAME[$i]} | gzip > $DB_BP_DIR/${DATABASE_DB_NAME[$i]}-`date '+%m-%d-%Y'`.sql.gz
RESULT=`echo $?`
if [ $RESULT == 0 ] ;then
        echo "Result: ${DATABASE_DB_NAME[$i]} Backup completed successfuly." >> $LOG_DIR
	find $DB_BP_DIR -name '*.gz' -mtime +$TTY_BACKUP -exec rm -f {} \; &>> $LOG_DIR
else
	echo "Result: Unfortunately database ${DATABASE_DB_NAME[$i]} backup does not completed." >> $LOG_DIR
fi

((i++))
done

