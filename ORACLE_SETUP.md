# Oracle Enterprise Connector - Setup Guide

## Overview

The Oracle Enterprise Connector for Atlan provides comprehensive metadata extraction capabilities from Oracle databases. This guide covers detailed setup instructions, configuration options, and troubleshooting steps for various deployment scenarios.

## System Requirements

### Software Dependencies

- Python 3.11+
- uv (Python package manager)
- Oracle Instant Client 19.8+
- Docker (optional, for local development)

### Oracle Database Compatibility

- Oracle Database 11g or later
- Oracle Cloud Database (including Autonomous Database)
- Oracle Database Enterprise Edition
- Oracle Database Standard Edition
- Oracle Database Express Edition

### Hardware Requirements

- Minimum 4GB RAM
- 2 CPU cores
- 10GB available disk space

## Installation Steps

### 1. Oracle Instant Client Setup

#### macOS Installation

```bash
# Using Homebrew
brew tap InstantClientTap/instantclient
brew install instantclient-basic
brew install instantclient-sqlplus

# Set environment variables (add to ~/.zshrc or ~/.bash_profile)
export ORACLE_HOME=/usr/local/lib/instantclient_19_8
export LD_LIBRARY_PATH=$ORACLE_HOME:$LD_LIBRARY_PATH
export PATH=$ORACLE_HOME:$PATH
```

#### Linux (Ubuntu/Debian) Installation

```bash
# Install system dependencies
sudo apt-get update
sudo apt-get install -y libaio1 unzip

# Download and install Oracle Instant Client
wget https://download.oracle.com/otn_software/linux/instantclient/1916000/instantclient-basic-linux.x64-19.16.0.0.0dbru.zip
unzip instantclient-basic-linux.x64-19.16.0.0.0dbru.zip -d /opt/oracle
sudo sh -c "echo /opt/oracle/instantclient_19_16 > /etc/ld.so.conf.d/oracle-instantclient.conf"
sudo ldconfig

# Set environment variables (add to ~/.bashrc)
export ORACLE_HOME=/opt/oracle/instantclient_19_16
export LD_LIBRARY_PATH=$ORACLE_HOME:$LD_LIBRARY_PATH
export PATH=$ORACLE_HOME:$PATH
```

### 2. Application Setup

```bash
# Clone the repository (if not already done)
git clone https://github.com/your-org/oracle-connector
cd oracle-connector

# Install dependencies
uv sync --all-groups --all-extras

# Create environment file
cp .env.example .env
```

## Configuration

### Environment Variables

| Variable                 | Description                    | Default | Required |
| ------------------------ | ------------------------------ | ------- | -------- |
| `ORACLE_HOST`            | Database hostname/IP           | -       | Yes      |
| `ORACLE_PORT`            | Database port                  | 1521    | Yes      |
| `ORACLE_USER`            | Database username              | -       | Yes      |
| `ORACLE_PASSWORD`        | Database password              | -       | Yes      |
| `ORACLE_DATABASE`        | Service name or SID            | -       | Yes      |
| `ORACLE_WALLET_LOCATION` | Oracle Wallet location         | -       | No       |
| `ORACLE_WALLET_PASSWORD` | Oracle Wallet password         | -       | No       |
| `LOG_LEVEL`              | Application log level          | INFO    | No       |
| `BATCH_SIZE`             | Metadata extraction batch size | 1000    | No       |
| `MAX_CONNECTIONS`        | Maximum database connections   | 10      | No       |

### Connection Examples

#### 1. Basic Connection (Service Name)

```bash
ORACLE_HOST=oracle.example.com
ORACLE_PORT=1521
ORACLE_USER=metadata_user
ORACLE_PASSWORD=secure_password
ORACLE_DATABASE=ORCL  # Service name
```

#### 2. Oracle Cloud Database

```bash
ORACLE_HOST=adb.us-phoenix-1.oraclecloud.com
ORACLE_PORT=1522
ORACLE_USER=ADMIN
ORACLE_PASSWORD=secure_password
ORACLE_DATABASE=mydb_high
ORACLE_WALLET_LOCATION=/path/to/wallet
ORACLE_WALLET_PASSWORD=wallet_password
```

#### 3. Container Database (CDB)

```bash
ORACLE_HOST=oracle.example.com
ORACLE_PORT=1521
ORACLE_USER=c##metadata_user
ORACLE_PASSWORD=secure_password
ORACLE_DATABASE=ORCLCDB
```

## Database User Setup

### 1. Create Metadata User

```sql
-- Connect as SYSDBA
CREATE USER metadata_user IDENTIFIED BY secure_password;

-- For Container Databases (CDB)
CREATE USER c##metadata_user IDENTIFIED BY secure_password CONTAINER=ALL;
```

### 2. Grant Required Privileges

```sql
-- Basic privileges
GRANT CREATE SESSION TO metadata_user;
GRANT SELECT_CATALOG_ROLE TO metadata_user;
GRANT SELECT ANY DICTIONARY TO metadata_user;

-- System view access
GRANT SELECT ON SYS.V_$VERSION TO metadata_user;
GRANT SELECT ON SYS.V_$DATABASE TO metadata_user;
GRANT SELECT ON SYS.ALL_USERS TO metadata_user;
GRANT SELECT ON SYS.ALL_TABLES TO metadata_user;
GRANT SELECT ON SYS.ALL_VIEWS TO metadata_user;
GRANT SELECT ON SYS.ALL_TAB_COLUMNS TO metadata_user;
GRANT SELECT ON SYS.ALL_TAB_COMMENTS TO metadata_user;
GRANT SELECT ON SYS.ALL_COL_COMMENTS TO metadata_user;
GRANT SELECT ON SYS.ALL_CONSTRAINTS TO metadata_user;
GRANT SELECT ON SYS.ALL_CONS_COLUMNS TO metadata_user;
GRANT SELECT ON SYS.ALL_INDEXES TO metadata_user;
GRANT SELECT ON SYS.ALL_IND_COLUMNS TO metadata_user;
GRANT SELECT ON SYS.ALL_PROCEDURES TO metadata_user;
GRANT SELECT ON SYS.ALL_ARGUMENTS TO metadata_user;
```

## Performance Tuning

### 1. Database Connection Settings

```python
DB_CONFIG = {
    "template": "oracle+oracledb://{username}:{password}@{host}:{port}/{database}",
    "required": ["username", "password", "host", "port", "database"],
    "defaults": {
        "connect_timeout": 30,
        "pool_size": 10,
        "max_overflow": 20,
        "pool_timeout": 30,
        "pool_recycle": 3600,
        "pool_pre_ping": True
    }
}
```

### 2. Extraction Configuration

```python
metadata_config = {
    "batch_size": 1000,
    "parallel_degree": 4,
    "fetch_size": 5000,
    "timeout": 3600
}
```

## Troubleshooting

### Common Issues

#### 1. ORA-12541: TNS:no listener

**Cause**: Database listener is not running or connection details are incorrect
**Solutions**:

- Verify listener status: `lsnrctl status`
- Check TNS_ADMIN environment variable
- Validate tnsnames.ora configuration
- Test connection: `sqlplus username/password@host:port/service_name`

#### 2. ORA-12514: TNS:listener does not currently know of service

**Cause**: Service name is incorrect or not registered
**Solutions**:

- Check available services: `lsnrctl services`
- Try using SID instead of service name
- Verify service registration: `SELECT * FROM V$ACTIVE_SERVICES;`

#### 3. ORA-01017: invalid username/password

**Cause**: Authentication failure
**Solutions**:

- Verify credentials
- Check account status: `SELECT username, account_status FROM dba_users;`
- Reset password if needed
- Verify OS authentication settings

#### 4. DPI-1047: Oracle Client library not found

**Cause**: Oracle Instant Client not properly installed
**Solutions**:

- Verify ORACLE_HOME setting
- Check LD_LIBRARY_PATH
- Reinstall Oracle Instant Client
- Run `ldconfig` (Linux)

### Validation Steps

1. **Test Database Connection**

```bash
# Using SQLPlus
sqlplus username/password@host:port/service_name

# Using Python
python3 -c "
import oracledb
conn = oracledb.connect(user='username', password='password', dsn='host:port/service_name')
print('Connection successful!')
conn.close()
"
```

2. **Verify User Privileges**

```sql
-- Check granted roles
SELECT * FROM USER_ROLE_PRIVS;

-- Check system privileges
SELECT * FROM USER_SYS_PRIVS;

-- Check object privileges
SELECT * FROM USER_TAB_PRIVS;
```

3. **Test Metadata Queries**

```sql
-- Test schema access
SELECT * FROM ALL_USERS WHERE ROWNUM <= 5;

-- Test table access
SELECT * FROM ALL_TABLES WHERE ROWNUM <= 5;

-- Test view access
SELECT * FROM ALL_VIEWS WHERE ROWNUM <= 5;
```

## Monitoring

### 1. Application Logs

- Location: `logs/oracle_connector.log`
- Format: JSON structured logging
- Rotation: Daily with 7-day retention

### 2. Metrics

- Endpoint: `/metrics`
- Format: Prometheus
- Key metrics:
  - Extraction duration
  - Records processed
  - Error counts
  - Connection pool stats

### 3. Health Checks

- Endpoint: `/health`
- Checks:
  - Database connectivity
  - Authentication status
  - Resource availability

## Support

For issues and questions:

1. Check this troubleshooting guide
2. Review application logs
3. Test database connectivity
4. Contact Atlan support with:
   - Error messages
   - Log snippets
   - Environment details
   - Steps to reproduce
