from application_sdk.clients.sql import AsyncBaseSQLClient


class SQLClient(AsyncBaseSQLClient):
    """
    ORACLE client that handles connection string generation
    based on authentication type and manages database connectivity using SQLAlchemy.
    """

    DB_CONFIG = {
        "template": "oracle+oracledb://{username}:{password}@{host}:{port}/{database}",
        "required": ["username", "password", "host", "port", "database"],
        "defaults": {
            # Remove all unsupported parameters for oracledb driver
        },
    }
