# mariadb-install-backup
This respository will help you to install MariaDB on the remote host (CentOS 7) and also you can choose what type of MariaDB backup you need, like Full backup, database(s) backup and table(s) backup.

<br><br><br>


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

> name of database and tables are as an example here, Please change them before run the script 

```bash
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

```