# Atlan Oracle App - Codebase Overview

## Core Architecture

### 1. Application Components

- **FastAPI Server**: Main web application server for handling API requests
- **Temporal**: Workflow orchestration engine for reliable metadata extraction
- **DAPR**: Distributed application runtime for infrastructure abstraction
- **Atlas**: Metadata store integration for entity management

### 2. Directory Structure

```
.
├── app/                      # Core application code
│   ├── clients/            # Database connectivity
│   │   └── __init__.py    # Client implementation
│   └── sql/               # SQL query templates
│       ├── client_version.sql
│       ├── extract_column.sql
│       ├── extract_database.sql
│       ├── extract_schema.sql
│       ├── extract_table.sql
│       ├── filter_metadata.sql
│       ├── tables_check.sql
│       └── test_authentication.sql
├── components/              # Reusable components
├── frontend/               # Frontend assets
├── scripts/                # Utility scripts
├── tests/                  # Test suite
├── .cursor/                # Cursor IDE configuration
├── .env                    # Environment variables (gitignored)
├── main.py                # Application entry point
├── pyproject.toml         # Project configuration
├── uv.lock                # Dependencies lock file
└── README.md              # Project documentation
```

### 3. Key Components

#### A. Database Client (`app/clients/`)

- Extends BaseSQLClient from application-sdk
- Configures Oracle connection template
- Handles authentication (Basic, Wallet, IAM)
- Example:

```python
class SQLClient(BaseSQLClient):
    """Oracle client implementation"""

    DB_CONFIG = {
        "template": "oracle+cx_oracle://{username}:{password}@{host}:{port}/{service_name}",
        "required": ["username", "password", "host", "port", "service_name"],
    }
```

#### B. Activities (`app/activities/metadata_extraction/`)

- Extends BaseSQLMetadataExtractionActivities
- Defines Oracle-specific metadata queries
- Implements extraction logic
- Example:

```python
class OracleActivities(BaseSQLMetadataExtractionActivities):
    """Activities for Oracle metadata extraction"""

    fetch_database_sql = """
    SELECT SYS_CONTEXT('USERENV', 'DB_NAME') as database_name
    FROM dual;
    """

    fetch_schema_sql = """
    SELECT USERNAME as schema_name
    FROM ALL_USERS
    WHERE USERNAME NOT IN ('SYS', 'SYSTEM', 'OUTLN', 'DIP')
        AND USERNAME !~ '{normalized_exclude_regex}'
        AND USERNAME ~ '{normalized_include_regex}';
    """

    fetch_table_sql = """
    SELECT OWNER, TABLE_NAME, TABLESPACE_NAME, STATUS
    FROM ALL_TABLES
    WHERE OWNER !~ '{normalized_exclude_regex}'
        AND OWNER ~ '{normalized_include_regex}'
        {temp_table_regex_sql};
    """
```

#### C. Handler (`app/handlers/`)

- Extends SQLHandler for workflow request handling
- Implements preflight checks and metadata queries
- Example:

```python
class OracleWorkflowHandler(SQLHandler):
    """Handler for Oracle workflow requests"""

    tables_check_sql = """
    SELECT COUNT(*)
    FROM ALL_TABLES
    WHERE OWNER !~ '{normalized_exclude_regex}'
        AND OWNER ~ '{normalized_include_regex}'
        AND OWNER NOT IN ('SYS', 'SYSTEM', 'OUTLN')
    """

    metadata_sql = """
    SELECT USERNAME as schema_name
    FROM ALL_USERS
    WHERE USERNAME NOT IN ('SYS', 'SYSTEM', 'OUTLN', 'DIP')
    """
```

#### D. Workflow (`app/workflows/metadata_extraction/`)

- Uses BaseSQLMetadataExtractionWorkflow
- Orchestrates metadata extraction process
- Example:

```python
async def setup_workflow():
    """Setup and start the Oracle metadata extraction workflow"""

    workflow_client = get_workflow_client(application_name="oracle")
    await workflow_client.load()

    activities = OracleActivities(
        sql_client_class=SQLClient,
        handler_class=OracleWorkflowHandler
    )

    worker = Worker(
        workflow_client=workflow_client,
        workflow_classes=[BaseSQLMetadataExtractionWorkflow],
        workflow_activities=BaseSQLMetadataExtractionWorkflow.get_activities(
            activities
        ),
    )

    workflow_args = {
        "credentials": {
            "authType": "basic",
            "host": os.getenv("ORACLE_HOST", "localhost"),
            "port": os.getenv("ORACLE_PORT", "1521"),
            "username": os.getenv("ORACLE_USER", "system"),
            "password": os.getenv("ORACLE_PASSWORD", "password"),
            "service_name": os.getenv("ORACLE_SERVICE_NAME", "ORCLPDB1"),
        },
        "connection": {
            "connection_name": "test-connection",
            "connection_qualified_name": "default/oracle/1728518400",
        },
        "metadata": {
            "exclude-filter": "{}",
            "include-filter": "{}",
            "temp-table-regex": "",
            "extraction-method": "direct",
            "exclude_views": "true",
            "exclude_empty_tables": "false",
        }
    }

    return await workflow_client.start_workflow(
        workflow_args,
        BaseSQLMetadataExtractionWorkflow
    )
```

### 4. Infrastructure Components

#### A. Temporal

- **Purpose**: Workflow orchestration
- **Features**:
  - Workflow versioning
  - Activity retries with backoff
  - Workflow timeouts
  - Progress tracking

#### B. DAPR

- **Purpose**: Infrastructure abstraction
- **Building Blocks**:
  - State management
  - Secrets handling
  - Service invocation
  - Pub/sub messaging

### 5. Key Features

#### A. Metadata Extraction

- Extract database schema information
- Transform to Atlas format
- Store in object storage
- Handle incremental updates

#### B. Authentication

- Basic authentication
- Wallet authentication
- IAM authentication
- Connection pooling

#### C. Observability

- OpenTelemetry integration
- Metrics collection
- Distributed tracing
- Logging

### 6. Development Workflow

#### A. Local Setup

1. Install dependencies (uv)
2. Configure environment
3. Start local services
4. Run application

#### B. Testing

- Unit tests
- Integration tests
- E2E tests
- Test utilities

### 7. Extending for New Databases

#### A. Required Components

1. Database Client
2. SQL Queries
3. Workflow Handler
4. Metadata Activities
5. Atlas Transformers
6. Frontend Support

#### B. Implementation Steps

1. Add SQLAlchemy dialect
2. Create component structure
3. Implement core logic
4. Add tests
5. Update frontend

### 8. Best Practices

#### A. Code Organization

- Modular structure
- Clear separation of concerns
- Consistent naming
- Documentation

#### B. Error Handling

- Graceful degradation
- Retry mechanisms
- Error reporting
- State recovery

#### C. Security

- Secure credential handling
- Token management
- Access control
- Audit logging

### 9. Configuration

#### A. Environment Variables

- Database settings
- Authentication configs
- Service endpoints
- Feature flags

#### B. Application Settings

- Workflow configurations
- Activity timeouts
- Retry policies
- Resource limits
