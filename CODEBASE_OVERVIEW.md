# Oracle Enterprise Connector - Codebase Overview

## Architecture Overview

The Oracle Enterprise Connector is built on Atlan's Application SDK, providing robust metadata extraction capabilities from Oracle databases. The codebase follows a modular architecture with clear separation of concerns.

## Directory Structure

```
oracle-connector/
├── app/                    # Core application code
│   ├── activities/         # Metadata extraction activities
│   ├── clients/           # Database connection handling
│   ├── handlers/          # Request handlers and workflow triggers
│   ├── transformers/      # Data transformation logic
│   │   └── atlas/        # Atlas entity transformations
│   └── workflows/         # Workflow definitions
├── tests/                 # Test suite
│   ├── unit/             # Unit tests
│   └── integration/      # Integration tests
├── docs/                 # Documentation
├── .env.example         # Environment variable template
├── pyproject.toml       # Project configuration
└── README.md           # Project documentation
```

## Core Components

### 1. Database Client (`app/clients/`)

The Oracle client implementation extends `BaseSQLClient` and handles:

- Connection pooling and management
- Query execution and error handling
- Oracle-specific connection parameters
- Wallet configuration for cloud databases

Key files:

- `__init__.py`: Client initialization and configuration
- `oracle_client.py`: Oracle-specific connection handling
- `connection_pool.py`: Connection pool management

### 2. Metadata Activities (`app/activities/`)

Activities for extracting different types of metadata:

- Schema extraction
- Table and view metadata
- Column details and data types
- Constraints and relationships
- Stored procedures and functions

Key files:

- `schema_extractor.py`: Schema-level metadata extraction
- `table_extractor.py`: Table metadata extraction
- `column_extractor.py`: Column-level details extraction
- `relationship_extractor.py`: Foreign key and constraint extraction

### 3. Data Transformers (`app/transformers/`)

Transform Oracle metadata into Atlas entities:

- Type mapping between Oracle and Atlas
- Entity relationship handling
- Custom attribute mapping
- Classification assignment

Key files:

- `atlas/oracle_types.py`: Oracle to Atlas type mappings
- `atlas/entity_transformer.py`: Entity transformation logic
- `atlas/relationship_transformer.py`: Relationship handling

### 4. Workflows (`app/workflows/`)

Define metadata extraction workflows:

- Full extraction process
- Incremental updates
- Error handling and retries
- Progress tracking

Key files:

- `metadata_extraction/__init__.py`: Main extraction workflow
- `metadata_extraction/incremental.py`: Incremental update workflow
- `metadata_extraction/error_handler.py`: Error handling strategies

### 5. Request Handlers (`app/handlers/`)

Handle incoming requests and trigger workflows:

- Request validation
- Workflow orchestration
- Response formatting
- Error handling

Key files:

- `__init__.py`: Handler registration
- `oracle_handler.py`: Oracle-specific request handling
- `validation.py`: Request validation logic

## Key Features

1. **Robust Connection Management**

   - Connection pooling with configurable limits
   - Automatic reconnection handling
   - Support for various Oracle connection methods
   - Oracle Wallet integration

2. **Comprehensive Metadata Extraction**

   - Schema-level metadata
   - Table and view details
   - Column properties and data types
   - Constraints and relationships
   - Stored procedures and functions
   - User-defined types

3. **Performance Optimization**

   - Batch processing
   - Parallel extraction
   - Configurable batch sizes
   - Connection pool tuning

4. **Error Handling & Reliability**
   - Automatic retries
   - Transaction management
   - Error logging and reporting
   - Partial success handling

## Testing Strategy

1. **Unit Tests**

   - Component-level testing
   - Mocked database interactions
   - Transformation logic validation
   - Error handling verification

2. **Integration Tests**
   - End-to-end workflow testing
   - Real database connections
   - Data consistency validation
   - Performance benchmarking

## Development Workflow

1. **Local Development**

   ```bash
   # Setup development environment
   uv sync --all-groups --all-extras
   cp .env.example .env

   # Run tests
   uv run pytest tests/unit
   uv run pytest tests/integration

   # Run pre-commit hooks
   uv run pre-commit run --all-files
   ```

2. **Code Quality**
   - Pre-commit hooks for code formatting
   - Type checking with mypy
   - Linting with flake8
   - Security scanning with bandit

## Configuration Management

1. **Environment Variables**

   - Database connection settings
   - Authentication parameters
   - Performance tuning options
   - Logging configuration

2. **Runtime Configuration**
   - Batch processing settings
   - Connection pool parameters
   - Retry policies
   - Extraction filters

## Monitoring & Observability

1. **Logging**

   - Structured JSON logging
   - Configurable log levels
   - Rotation policies
   - Error tracking

2. **Metrics**
   - Extraction performance
   - Connection pool stats
   - Error rates
   - Processing times

## Security Considerations

1. **Authentication**

   - Secure credential handling
   - Oracle Wallet support
   - Role-based access control
   - Session management

2. **Data Protection**
   - Sensitive data handling
   - Secure connection methods
   - Audit logging
   - Access controls

## Future Enhancements

1. **Planned Features**

   - Real-time change detection
   - Advanced filtering options
   - Custom metadata extensions
   - Enhanced performance monitoring

2. **Technical Debt**
   - Connection pool optimization
   - Error handling refinement
   - Test coverage expansion
   - Documentation updates
