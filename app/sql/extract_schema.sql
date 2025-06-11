/*
 * File: extract_schema.sql
 * Purpose: Extracts schema metadata from ORACLE
 *
 * Parameters:
 *   {normalized_exclude_regex} - Regex pattern for schemas to exclude
 *   {normalized_include_regex} - Regex pattern for schemas to include
 *
 * Returns:
 *   - Schema names and metadata
 */
SELECT 
    NULL as catalog_name,
    u.USERNAME as schema_name,
    u.USERNAME as schema_owner,
    'SCHEMA' as schema_type
FROM 
    ALL_USERS u
WHERE 
    u.USERNAME NOT IN ('SYS', 'SYSTEM', 'CTXSYS', 'MDSYS', 'DBSNMP', 'WMSYS', 'XDB', 'APEX_030200', 'FLOWS_FILES', 'HR', 'OE', 'PM', 'IX', 'SH', 'BI')
ORDER BY 
    u.USERNAME
