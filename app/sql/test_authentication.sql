/*
 * File: test_authentication.sql
 * Purpose: Simple query to test ORACLE connectivity and authentication
 *
 * Returns:
 *   - Simple result to verify connection
 */
SELECT 
    USER as current_user,
    SYS_CONTEXT('USERENV', 'DB_NAME') as current_database,
    'Connection successful' as status
FROM 
    DUAL
