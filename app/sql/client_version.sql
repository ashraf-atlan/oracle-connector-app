/*
 * File: client_version.sql
 * Purpose: Get ORACLE version information
 *
 * Returns:
 *   - Database version and build information
 */
SELECT 
    'Oracle Database' as version,
    SYSDATE as query_time
FROM 
    DUAL
