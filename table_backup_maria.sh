#!/bin/bash

#title           :table_backup_maria.sh
#description     :This script will create backup from table(s) of MAriaDB.
#author          :Mehrdad Faridi
#date            :2021/28/May
#version         :0.7
#usage           :bash table_backup_maria.sh
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
TABLE_BP_DIR="/root/maria_backup/table-backup"
LOG_DIR="/var/log/mybackup-mariadb.log"
DB_USER="ROOT"
DB_PASS="pass"
TABLE_DB_NAME="test"
TABLE_NAME=(test)
TTY_BACKUP="5"
###################################

touch $LOG_DIR
#Print number of elements TABLE_NAME
tb_length=${#TABLE_NAME[@]}
i=0
while [ $i -lt $tb_length ]
do
echo -e "######################################## Create ${TABLE_NAME[$i]} Table backup `date '+%Y-%m-%d__%H:%M:%S'` ########################################" >> $LOG_DIR
echo -e "$yellow_color Creating table: ${TABLE_NAME[$i]} backup starting, Please wait...$default_color"
mysqldump --user $DB_USER -p$DB_PASS --databases $TABLE_DB_NAME ${TABLE_NAME[$i]} > $TABLE_BP_DIR/${TABLE_NAME[$i]}_$TABLE_DB_NAME-`date '+%m-%d-%Y'`.sql.gz
RESULT=`echo $?`
if [ $RESULT == 0 ] ;then
        echo "Result: Table ${TABLE_NAME[$i]} Backup completed successfuly." >> $LOG_DIR
	find $TABLE_BP_DIR -name '*.gz' -mtime +$TTY_BACKUP -exec rm -f {} \; &>> $LOG_DIR
else
	echo "Result: Unfortunately ${TABLE_NAME[$i]} backup does not completed." >> $LOG_DIR
fi


((i++))
done
