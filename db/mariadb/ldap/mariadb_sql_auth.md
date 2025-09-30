That's a great choice for centralized authentication\! Using **Pluggable Authentication Modules (PAM)** allows MariaDB to authenticate users against operating system credentials, LDAP, Kerberos, or other PAM services configured on your server.

Here is a step-by-step guide covering the necessary MariaDB configuration, user rights, and Python sample code.

-----

## 1\. MariaDB Server Setup (PAM Configuration)

The MariaDB PAM authentication plugin (`auth_pam`) delegates password checking to the host operating system's PAM stack.

### A. OS-Level PAM Configuration

This step is performed on the MariaDB server host.

1.  **Check/Install the Plugin:** Ensure the `auth_pam` plugin is installed in MariaDB:

    ```sql
    -- Connect as root or an admin user
    INSTALL SONAME 'auth_pam';
    SELECT PLUGIN_NAME, PLUGIN_STATUS FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_NAME = 'auth_pam';
    ```

2.  **Create the PAM Service File:** MariaDB uses a specific PAM service file, usually named `/etc/pam.d/mysql` or `/etc/pam.d/mariadb`. Create this file and define the desired authentication method (e.g., standard Unix authentication).

      * **File Path:** `/etc/pam.d/mysql` (or `/etc/pam.d/mariadb`)

      * **Content (Standard Unix Authentication):**

        ```conf
        #%PAM-1.0
        auth    required    pam_unix.so
        account required    pam_unix.so
        ```

      * *Note: If you are using LDAP, Kerberos, or another service, you would use their respective PAM modules here (e.g., `pam_ldap.so`). The name of this file (e.g., `mysql`) is the **PAM service name** you will use when creating the MariaDB user.*

3.  **Ensure Shadow File Access (Critical):** For `pam_unix.so` to work, the MariaDB server process often needs read access to `/etc/shadow`. This is a security consideration and typically involves:

    ```bash
    # 1. Add the MariaDB user to the 'shadow' group
    sudo usermod -a -G shadow mysql 
    # 2. Change permissions on /etc/shadow for group read access
    sudo chmod g+r /etc/shadow
    # 3. Restart the MariaDB service
    sudo systemctl restart mariadb
    ```

-----

## 2\. MariaDB User Creation and Permissions

Once the PAM plugin is active and the PAM service file is configured, you create a MariaDB user account linked to the external PAM authentication.

We will create a user named `alice` who authenticates using her OS password via the PAM service named `mysql`.

### A. Create the PAM-Authenticated User

Use `IDENTIFIED VIA pam` and the name of the PAM service file in the `USING` clause.

```sql
-- Replace 'alice' with the OS username
-- Replace 'mysql' with the name of your PAM service file (e.g., /etc/pam.d/mysql)
CREATE USER 'alice'@'%' IDENTIFIED VIA pam USING 'mysql';

-- Connect from localhost using Unix socket (no password needed for PAM)
CREATE USER 'alice'@'localhost' IDENTIFIED VIA pam USING 'mysql';

-- Optional: If the PAM authentication succeeds, the client must use the
-- `mysql_clear_password` client plugin to transmit the OS password to the server.
-- In some older MariaDB versions or specific setups, you might need to use the
-- `auth_pam_compat` plugin, which explicitly requires cleartext transmission.
```

### B. Setting Permissions and Rights (GRANT Statement)

A user must have privileges defined *within* MariaDB even if they authenticate externally. Use the `GRANT` statement to set rights.

| Privilege Level | Target | Example Command |
| :--- | :--- | :--- |
| **Global** | All databases, all tables (`*.*`) | `GRANT ALL PRIVILEGES ON *.* TO 'alice'@'%';` |
| **Database** | Specific database (`db_name.*`) | `GRANT SELECT, INSERT, UPDATE ON payroll_db.* TO 'alice'@'%';` |
| **Table** | Specific table (`db_name.table_name`) | `GRANT SELECT ON payroll_db.employee_info TO 'alice'@'%';` |

**Example of Granting Specific Permissions to `alice`:**

```sql
-- 1. Create a sample database
CREATE DATABASE employee_data;

-- 2. Grant SELECT and INSERT privileges on the new database to the PAM user 'alice' from any host ('%')
GRANT SELECT, INSERT
ON employee_data.*
TO 'alice'@'%';

-- 3. Review the granted privileges
SHOW GRANTS FOR 'alice'@'%';

-- Note: FLUSH PRIVILEGES is generally not needed after GRANT/CREATE USER but is harmless.
```

-----

## 3\. Python Code Setup and Sample

For Python, you'll use a MariaDB/MySQL connector library. The most common is **`mysql-connector-python`** or **`PyMySQL`**.

### A. Python Setup

Install the recommended connector:

```bash
pip install mysql-connector-python
```

### B. Python Sample Code

When connecting to a user configured with the `auth_pam` plugin, the client simply provides the **OS username** and the **OS password**. The MariaDB server handles the PAM delegation.

```python
import mysql.connector
import getpass
import sys

# --- Settings ---
# This OS user must exist on the MariaDB server host and be configured
# in MariaDB using IDENTIFIED VIA pam.
DB_USER = "alice"
DB_HOST = "your_mariadb_server_ip" # Use '127.0.0.1' or 'localhost' if running locally
DB_NAME = "employee_data"

def connect_to_mariadb_with_pam():
    """Connects to MariaDB using OS credentials authenticated via PAM."""
    
    print(f"Attempting to authenticate as OS user: {DB_USER}")
    
    # Prompt the user for their OS password
    # This password will be sent to MariaDB, which forwards it to the PAM stack.
    try:
        os_password = getpass.getpass(f"Enter OS password for {DB_USER}: ")
    except EOFError:
        print("\nInput cancelled. Exiting.")
        sys.exit(1)
        
    try:
        # The connector handles sending the clear password for the PAM plugin
        cnx = mysql.connector.connect(
            user=DB_USER,
            password=os_password,
            host=DB_HOST,
            database=DB_NAME,
            # It's highly recommended to use SSL/TLS for connections using PAM/cleartext passwords
            # ssl_disabled=False 
        )
        
        print("\n✅ Connection successful!")
        
        # Example Query
        cursor = cnx.cursor()
        cursor.execute("SELECT CURRENT_USER(), USER(), VERSION()")
        result = cursor.fetchone()
        
        print(f"Authenticated as MariaDB user: {result[0]}")
        print(f"Client user/host: {result[1]}")
        print(f"MariaDB Version: {result[2]}")
        
        cursor.close()
        
    except mysql.connector.Error as err:
        if err.errno == 1045:
            # Error 1045 is typically "Access denied" (incorrect credentials or PAM failure)
            print(f"\n❌ Authentication Failed: Access denied for '{DB_USER}'")
            print("   Check your OS password, MariaDB user configuration, and PAM service file.")
        else:
            print(f"\n❌ Database Connection Error: {err}")
    
    finally:
        if 'cnx' in locals() and cnx.is_connected():
            cnx.close()
            print("Connection closed.")

if __name__ == "__main__":
    connect_to_mariadb_with_pam()
```
