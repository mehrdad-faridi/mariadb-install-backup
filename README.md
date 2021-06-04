# mariadb-install-backup
This respository will help you to install MariaDB on the remote host (CentOS 7) and also you can choose what type of MariaDB backup you need, like Full backup, database(s) backup and table(s) backup.
<br>

All the backup script will generate a log file `/var/log/mybackup-mariadb.log` due to get more details of backup result.
<br><br><br>

# What you can do with this script:
- Add MAriaDB repo and Install(on remote host)
- Create full backup of mysql
- Create database(s) backup
- Create table(s) backup
- Auto craete backup based on crontab
- Auto remove old backup file
- Log file of backup result

<br><br>

# Tree of directories and files
```
|── database_backup_maria.sh
├── full_backup_maria.sh
├── install_maria.sh
├── LICENSE
├── README.md
└── table_backup_maria.sh
```
<br>

# How to use
It design with menu, the only thing you need change before run the script is `variables` portion in the `install_maria.sh` file.
here is those variables you have to change: 


<br>

> name of database and tables in here are as an example, Please change them before run the script 

```bash
#remote host IP
HOST_IP="<REMOTE_IP_ADDRESS>"
#remote host port
HOST_PORT="22"
#remote user
HOST_USER="root"
#password of mysql_secure_installation command
MAARIA_PASS="mypass"
#script and backup path on the remote host
SCRIPT_DIR="/root/maria_backup"
#time of creating backup(cron)
CRONTAB_TIME="3 0 * * *"
#how long the backup file will persist (based on day)
TTY_BACKUP="3"
#database username
DB_USER="root"
#database password
DB_PASS="pass"

### full backup variable
FULL_BP_DIR="$SCRIPT_DIR/full-backup"
FULL_BP_SCRIPT_NAME="full_backup_maria.sh"

### database backup variable
DB_BP_DIR="$SCRIPT_DIR/db-backup"
DATABASE_BP_SCRIPT_NAME="database_backup_maria.sh"
DATABASE_DB_NAME=(test1 test2 test3 test4 test5)

### table backup variable
TABLE_BP_DIR="$SCRIPT_DIR/table-backup"
TABLE_BP_SCRIPT_NAME="table_backup_maria.sh"
TABLE_DB_NAME="test"
TABLE_NAME=(test1 test2 test3)

```
<br>
Execute script:

```bash
./install_maria.sh
```