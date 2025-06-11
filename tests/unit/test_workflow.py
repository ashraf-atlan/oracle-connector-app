import pytest
from unittest.mock import AsyncMock, MagicMock

from app.clients import SQLClient


class TestORACLEWorkflow:
    """Test suite for ORACLE workflow operations."""

    @pytest.fixture
    def mock_credentials(self):
        """Mock database credentials for testing."""
        return {
            "authType": "basic",
            "host": "localhost",
            "port": "1521",
            "username": "test_user",
            "password": "test_password",
            "database": "test_database",
        }

    @pytest.fixture
    def mock_connection_config(self):
        """Mock connection configuration."""
        return {
            "connection_name": "test-connection",
            "connection_qualified_name": "default/oracle/test",
        }

    @pytest.fixture
    def mock_metadata_config(self):
        """Mock metadata extraction configuration."""
        return {
            "exclude-filter": "{}",
            "include-filter": "{}",
            "temp-table-regex": "",
            "extraction-method": "direct",
            "exclude_views": "false",
            "exclude_empty_tables": "false",
        }

    @pytest.mark.asyncio
    async def test_sql_client_initialization(self, mock_credentials):
        """Test SQL client can be initialized with credentials."""
        client = SQLClient()
        
        # Test connection string generation
        connection_string = await client.get_connection_string(mock_credentials)
        assert connection_string is not None
        assert "localhost" in connection_string

    def test_db_config_validation(self):
        """Test database configuration is properly set."""
        client = SQLClient()
        
        assert hasattr(client, 'DB_CONFIG')
        assert 'template' in client.DB_CONFIG
        assert 'required' in client.DB_CONFIG
        assert isinstance(client.DB_CONFIG['required'], list)
        assert "oracle+oracledb" in client.DB_CONFIG['template']
