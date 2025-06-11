# Oracle Enterprise Connector for Atlan

A robust metadata extraction application for Oracle databases built using the Atlan Application SDK. This connector enables comprehensive metadata discovery and cataloging from Oracle databases into Atlan's data catalog.

## Key Features

- **Comprehensive Metadata Extraction**: Extract detailed metadata from Oracle databases including schemas, tables, views, columns, and their relationships
- **Multiple Authentication Methods**: Support for Basic Auth, Oracle Wallet, and IAM authentication
- **Advanced Filtering**: Flexible include/exclude patterns for schema and table selection
- **Performance Optimized**: Parallel processing and connection pooling for large Oracle databases
- **Robust Error Handling**: Built-in retry mechanisms and detailed error reporting
- **Full Observability**: Comprehensive logging, metrics, and distributed tracing
- **Enterprise Ready**: Support for Oracle Database 11g and later, including cloud deployments

## Prerequisites

- Python 3.11+
- uv (Python package manager)
- Oracle Instant Client 19.8+
- Docker (for local development dependencies)
- Access to an Oracle database

## Quick Start

### 1. Install Oracle Instant Client

#### macOS

```bash
brew tap InstantClientTap/instantclient
brew install instantclient-basic
brew install instantclient-sqlplus
```

#### Linux (Ubuntu/Debian)

```bash
sudo apt-get update
sudo apt-get install libaio1
wget https://download.oracle.com/otn_software/linux/instantclient/instantclient-basic-linux.x64-19.16.0.0.0dbru.zip
unzip instantclient-basic-linux.x64-19.16.0.0.0dbru.zip
```

### 2. Set Environment Variables

```bash
export ORACLE_HOME=/path/to/instantclient
export LD_LIBRARY_PATH=$ORACLE_HOME:$LD_LIBRARY_PATH
export PATH=$ORACLE_HOME:$PATH
```

### 3. Install Application Dependencies

```bash
uv sync --all-groups --all-extras
```

### 4. Configure Environment

Create a `.env` file:

```bash
ORACLE_HOST=your-oracle-host
ORACLE_PORT=1521
ORACLE_USER=your_username
ORACLE_PASSWORD=your_password
ORACLE_DATABASE=your_service_name
```

### 5. Start Dependencies

```bash
uv run poe start-deps
```

### 6. Run the Application

```bash
uv run python main.py
```

## Development

### Project Structure

```
.
├── app/                    # Core application code
│   ├── activities/        # Metadata extraction activities
│   ├── clients/          # Oracle database client
│   ├── handlers/         # Request handlers
│   ├── transformers/     # Data transformers
│   └── workflows/        # Workflow definitions
├── docs/                  # Documentation
├── tests/                 # Test suite
└── frontend/             # UI components
```

### Running Tests

```bash
# Unit tests
uv run pytest tests/unit

# Integration tests
uv run pytest tests/integration

# All tests with coverage
uv run pytest --cov=app tests/
```

### Code Quality

```bash
# Run all pre-commit hooks
uv run pre-commit run --all-files

# Run specific checks
uv run ruff check .
uv run black .
uv run mypy .
```

## Configuration

### Authentication Methods

1. **Basic Authentication**

```python
credentials = {
    "authType": "basic",
    "username": "user",
    "password": "pass",
    "host": "host",
    "port": 1521,
    "database": "service_name"
}
```

2. **Oracle Wallet**

```python
credentials = {
    "authType": "wallet",
    "wallet_location": "/path/to/wallet",
    "wallet_password": "password",
    "service_name": "service_name"
}
```

### Metadata Extraction Filters

```python
metadata_config = {
    "exclude-filter": "^(TEMP_|TEST_).*",  # Exclude temp/test schemas
    "include-filter": ".*",                # Include all schemas
    "temp-table-regex": "^TMP_.*",        # Exclude temporary tables
    "exclude_views": "false",             # Include views
    "exclude_empty_tables": "true"        # Skip empty tables
}
```

## Troubleshooting

See [ORACLE_SETUP.md](ORACLE_SETUP.md) for detailed troubleshooting steps and common issues.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and quality checks
5. Submit a pull request

## License

Copyright © 2024 Atlan Pte. Ltd.
