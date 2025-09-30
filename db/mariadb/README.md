Here is a MariaDB Developer Cheat Sheet in Markdown format, based on common SQL commands and administration tasks.

-----

# 🐘 MariaDB Standard Developer Cheat Sheet

This cheat sheet covers essential commands for connecting, managing databases and tables, manipulating data, and managing users/permissions.

## 1\. CLI and Connection

| Task | Command |
| :--- | :--- |
| **Connect to local server** (will prompt for password) | `mysql -u root -p` |
| **Connect to a specific database** | `mysql -u [username] -p [database_name]` |
| **Connect to a remote host** | `mysql -h [host] -u [username] -p` |
| **Quit the MariaDB shell** | `exit` or `quit` or `\q` |
| **Start/Stop Service** (on Linux) | `sudo systemctl start mariadb` |

-----

## 2\. Database Management (DDL)

| Task | Command |
| :--- | :--- |
| **List all databases** | `SHOW DATABASES;` |
| **Create a new database** | `CREATE DATABASE [db_name];` |
| **Select a database to use** | `USE [db_name];` |
| **Show the current database** | `SELECT DATABASE();` |
| **Drop a database** | `DROP DATABASE [db_name];` |

-----

## 3\. Table Management (DDL)

| Task | Command |
| :--- | :--- |
| **List tables in current DB** | `SHOW TABLES;` |
| **Describe table structure/columns** | `DESCRIBE [table_name];` or `SHOW COLUMNS FROM [table_name];` |
| **Create a new table** | `CREATE TABLE [table_name] ( column1 DATATYPE PRIMARY KEY, column2 DATATYPE NOT NULL, column3 DATATYPE );` |
| **Add a new column** | `ALTER TABLE [table_name] ADD COLUMN [new_col] DATATYPE;` |
| **Modify an existing column** | `ALTER TABLE [table_name] MODIFY COLUMN [col] DATATYPE;` |
| **Drop a column** | `ALTER TABLE [table_name] DROP COLUMN [col];` |
| **Drop a table** | `DROP TABLE [table_name];` |
| **Delete all data from a table** (resets `AUTO_INCREMENT`) | `TRUNCATE TABLE [table_name];` |

-----

## 4\. Data Manipulation (DML)

### Basic Commands

| Task | Command |
| :--- | :--- |
| **Insert a new record** | `INSERT INTO [table] ([col1], [col2]) VALUES ('value1', 100);` |
| **Update existing records** | `UPDATE [table] SET [col] = '[new_value]' WHERE [condition];` |
| **Delete records** | `DELETE FROM [table] WHERE [condition];` |

### SELECT Statements

| Task | Example Query |
| :--- | :--- |
| **Select all columns/records** | `SELECT * FROM [table_name];` |
| **Select specific columns** | `SELECT [col1], [col2] FROM [table_name];` |
| **Select with a condition** | `SELECT * FROM [table] WHERE [col] = 'value';` |
| **Select with ordering** | `SELECT * FROM [table] ORDER BY [col] DESC;` (Use `ASC` for ascending) |
| **Limit results** | `SELECT * FROM [table] LIMIT 10;` |
| **Wildcard search** (contains 'word') | `SELECT * FROM [table] WHERE [col] LIKE '%word%';` |
| **Aliasing a column** | `SELECT COUNT([id]) AS total_count FROM [table];` |

### Aggregation and Grouping

| Function | Description |
| :--- | :--- |
| `COUNT([col])` | Returns the number of rows. |
| `SUM([col])` | Returns the sum of values. |
| `AVG([col])` | Returns the average value. |
| `MAX([col])` | Returns the maximum value. |
| `MIN([col])` | Returns the minimum value. |

**Example of Grouping:**

```sql
-- Count the number of customers in each country
SELECT country, COUNT(customer_id)
FROM customers
GROUP BY country
HAVING COUNT(customer_id) > 5;
```

### Joins

| Join Type | Description |
| :--- | :--- |
| **INNER JOIN** | Returns records that have matching values in both tables. |
| **LEFT JOIN** | Returns all records from the left table, and the matched records from the right table. |
| **RIGHT JOIN** | Returns all records from the right table, and the matched records from the left table. |

**Example of an INNER JOIN:**

```sql
SELECT T1.column_name, T2.column_name
FROM table1 AS T1
INNER JOIN table2 AS T2
  ON T1.matching_id = T2.matching_id;
```

-----

## 5\. User and Privilege Management

| Task | Command |
| :--- | :--- |
| **Create a new user** | `CREATE USER 'user_name'@'localhost' IDENTIFIED BY 'password';` |
| **Grant all privileges on a DB** | `GRANT ALL PRIVILEGES ON [db_name].* TO 'user_name'@'localhost';` |
| **Grant specific privileges** | `GRANT SELECT, INSERT ON [db_name].* TO 'user_name'@'%';` (use `'%'` for any host) |
| **Revoke privileges** | `REVOKE DELETE ON [db_name].* FROM 'user_name'@'localhost';` |
| **Show user's privileges** | `SHOW GRANTS FOR 'user_name'@'localhost';` |
| **Apply privilege changes** | `FLUSH PRIVILEGES;` |
| **Drop a user** | `DROP USER 'user_name'@'localhost';` |
