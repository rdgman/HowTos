# 🐘 Useful MySQL/MariaDB Queries and CLI Commands

-----

## CLI (Command Line Interface)

| Task | Command | Remark |
| :--- | :--- | :--- |
| **Log in as root** | `mysql -u root -p` | Password is prompted. |
| **Log in with password inline** | `mysql -u root -psekrit` | **NO SPACE** allowed between `-p` and the password. |
| **Log in remotely to a DB** | `mysql -h host -u user -p mydb` | Logs in as `user` on `host` and uses database `mydb` (password is prompted). |
| **Set the root password** | `mysqladmin password "my new password"` | Used typically after a clean install. |

-----

## Queries (Interactive Session)

To run these queries, first log in as root and use the system database: `mysql -uroot -p mysql`. Don't forget that every query must be terminated with a semicolon (`;`).

| Task | Query |
| :--- | :--- |
| **List databases** | `SHOW DATABASES;` |
| **Change active database** | `USE dbname;` |
| **Change to the system database** | `USE mysql;` |
| **Show tables in active database** | `SHOW TABLES;` |
| **Show table properties/schema** | `DESCRIBE tablename;` |
| **List all users** | `SELECT user,host,password FROM mysql.user;` |
| **List databases/privileges** | `SELECT host,db,user FROM mysql.db;` |
| **Quit the console** | `exit` or `Ctrl-D` |

-----

## Secure Installation & Automation

Most documentation suggests running the interactive script `mysql_secure_installation`, but for automated setups, you can use the following idempotent snippets.

### Setting the Root Password

This script sets the database root password only **if it is not already set**.

```bash
readonly mariadb_root_password=fogMeHud8

if mysqladmin -u root status > /dev/null 2>&1; then
  mysqladmin password "${mariadb_root_password}" > /dev/null 2>&1
  printf "database root password set\n"
else
  printf "skipping database root password: already set\n"
fi
```

### Removing Test Database and Anonymous Users

This snippet uses a **here document** to execute multiple SQL commands via the command line, cleaning up the installation.

```bash
mysql --user=root --password="${mariadb_root_password}" mysql <<_EOF_
DELETE FROM user WHERE User='';
DELETE FROM user WHERE User='root' AND host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM db WHERE db='test' OR db='test\\_%';
FLUSH PRIVILEGES;
_EOF_
```

### Create a New Database and User

This script creates a database and a dedicated user with **all privileges** for that database (it will first remove them if they already exist).

```bash
readonly db_user=myuser
readonly db_name=mydb
readonly db_password=TicJart2

mysql --user=root --password="${mariadb_root_password}" <<_EOF_
DROP USER IF EXISTS ${db_user};
DROP DATABASE IF EXISTS ${db_name};
CREATE DATABASE ${db_name};
GRANT ALL ON ${db_name}.* TO '${db_user}'@'%' IDENTIFIED BY PASSWORD('${db_password}');
FLUSH PRIVILEGES;
_EOF_
```

-----

## Backup and Restore

### Backup

To backup the `drupal` database:

```bash
mysqldump -u root -p drupal > drupal_backup.sql
```

### Restore

First, ensure that the `drupal` database exists (see the create database command above).

```bash
mysql -u root -p drupal < drupal_backup.sql
```
