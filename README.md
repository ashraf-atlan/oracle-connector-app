<p align="center">
  <img src="./frontend/static/oracle_icon.png" alt="Oracle Logo" width="200" height="auto">
</p>

# Oracle Application

[![Checked with pyright](https://microsoft.github.io/pyright/img/pyright_badge.svg)](https://microsoft.github.io/pyright/)
[![Ruff](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/astral-sh/ruff/main/assets/badge/v2.json)](https://github.com/astral-sh/ruff)
[![Tests](https://github.com/atlanhq/atlan-oracle-app/actions/workflows/unit-tests.yml/badge.svg)](https://github.com/atlanhq/atlan-oracle-app/actions/workflows/unit-tests.yml)

Oracle application is designed to interact with an Oracle database and perform actions on it. The application is built using the [Atlan Python Application SDK](https://github.com/atlanhq/application-sdk) and is intended to run on the Atlan Platform.

This application has two components:

- FastAPI server that exposes REST API to interact with the application.
- A workflow that runs on the Atlan platform that extracts metadata from an Oracle database, transforms it and pushes it to an object store.

https://github.com/user-attachments/assets/0ce63557-7c62-4491-96b9-1134a1ceadd6

## Table of contents

- [Usage](#usage)
- [Features](#features)
- [Extending this application to other SQL sources](#extending-this-application-to-other-sql-sources)
- [Development](#development)
- [Architecture](./docs/ARCHITECTURE.md)

## Usage

### Setting up your environment

1. Clone the repository:

   ```bash
   git clone https://github.com/atlanhq/atlan-oracle-app.git
   cd atlan-oracle-app
   ```

2. Follow the setup instructions for your platform:

   - [Automatic Setup](./.cursor/rules/setup.mdc) - Automatically detects your OS and provides the appropriate guide
   - [macOS Setup Guide](https://github.com/atlanhq/application-sdk/blob/main/docs/docs/setup/MAC.md)
   - [Linux Setup Guide](https://github.com/atlanhq/application-sdk/blob/main/docs/docs/setup/LINUX.md)
   - [Windows Setup Guide](https://github.com/atlanhq/application-sdk/blob/main/docs/docs/setup/WINDOWS.md)

3. Install dependencies:

   ```bash
   uv sync --all-groups
   ```

4. Download required components:

   ```bash
   uv run poe download-components
   ```

5. Start the dependencies (in a separate terminal):

   ```bash
   uv run poe start-deps
   ```

6. That loads all required dependencies. To run, you just run the command in the main terminal:
   ```bash
   uv run main.py
   ```

## Component Structure

The project follows a simple, modular structure:

- `app/`: Core application code
  - `clients/`: Database client implementations for Oracle connectivity
  - `sql/`: SQL query templates for metadata extraction:
    - `client_version.sql`: Query to fetch Oracle client version
    - `extract_column.sql`: Column metadata extraction
    - `extract_database.sql`: Database metadata extraction
    - `extract_schema.sql`: Schema metadata extraction
    - `extract_table.sql`: Table metadata extraction
    - `filter_metadata.sql`: Metadata filtering logic
    - `tables_check.sql`: Table validation queries
    - `test_authentication.sql`: Authentication test queries
- `components/`: Reusable components
- `frontend/`: Frontend assets
- `scripts/`: Utility scripts
- `tests/`: Test suite
- `main.py`: Application entry point

## Features

1. Extract metadata from an Oracle database, transform and push to an object store
2. FastAPI-based REST API interface
3. OpenTelemetry integration for metrics, traces and logs
4. Multiple authentication methods:
   - Basic Authentication
   - Oracle Wallet Authentication
   - IAM Authentication

### Note on Authentication Methods

This application supports multiple authentication methods:

1. **Basic Authentication**: Username/password authentication
2. **Oracle Wallet Authentication**: Using Oracle Wallet for secure credential storage
3. **IAM Authentication**: For cloud deployments

For IAM authentication, tokens are generated on-demand for each connection string creation. This approach ensures:

1. Fresh tokens for each new connection
2. Immediate connection creation after token generation
3. Proper token expiration handling

## Extending this application to other SQL sources

1. Make sure you add the required SQLAlchemy dialect using uv. For ex. to add MySQL dialect, `uv add mysql-connector-python`
2. Update SQL queries in [`sql`](app/sql) directory
3. Update the DB_CONFIG in the [`app/clients`](app/clients) directory
4. Run the application using the development guide
5. Update the tests in the [`tests`](tests) directory

## Development

- [Development and Quickstart Guide](./docs/DEVELOPMENT.md)
- This application is just an SQL application implementation of Atlan's [Python Application SDK](https://github.com/atlanhq/application-sdk)
  - Please refer to the [examples](https://github.com/atlanhq/application-sdk/tree/main/examples) in the SDK to see how to use the SDK to build different applications on the Atlan Platform.
