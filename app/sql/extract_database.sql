/*
 * File: extract_database.sql
 * Purpose: Extracts database metadata from ORACLE
 * 
 * Returns:
 *   - Database name and metadata
 */
SELECT 
    SYS_CONTEXT('USERENV', 'DB_NAME') as database_name,
    NULL as database_description,
    SYSDATE as created_date,
    USER as owner
FROM 
    DUAL
