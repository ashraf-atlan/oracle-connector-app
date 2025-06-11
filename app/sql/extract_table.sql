/*
 * File: extract_table.sql
 * Purpose: Extracts table and view metadata from ORACLE
 *
 * Returns:
 *   - Comprehensive table metadata
 */
SELECT 
    NULL as table_catalog,
    t.OWNER as table_schema,
    t.TABLE_NAME as table_name,
    'BASE TABLE' as table_type,
    NVL(t.NUM_ROWS, 0) as row_count,
    0 as column_count,
    c.COMMENTS as remarks,
    NULL as created_time,
    t.LAST_ANALYZED as last_modified_time
FROM 
    ALL_TABLES t
    LEFT JOIN ALL_TAB_COMMENTS c ON t.OWNER = c.OWNER AND t.TABLE_NAME = c.TABLE_NAME
WHERE 
    t.OWNER NOT IN ('SYS', 'SYSTEM', 'CTXSYS', 'MDSYS', 'DBSNMP', 'WMSYS', 'XDB', 'APEX_030200', 'FLOWS_FILES', 'HR', 'OE', 'PM', 'IX', 'SH', 'BI')
    AND t.OWNER NOT LIKE 'APEX_%'
    AND t.OWNER NOT LIKE 'FLOWS_%'
    AND t.TABLE_NAME NOT LIKE 'BIN$%'
UNION ALL
SELECT 
    NULL as table_catalog,
    v.OWNER as table_schema,
    v.VIEW_NAME as table_name,
    'VIEW' as table_type,
    0 as row_count,
    0 as column_count,
    c.COMMENTS as remarks,
    NULL as created_time,
    NULL as last_modified_time
FROM 
    ALL_VIEWS v
    LEFT JOIN ALL_TAB_COMMENTS c ON v.OWNER = c.OWNER AND v.VIEW_NAME = c.TABLE_NAME
WHERE 
    v.OWNER NOT IN ('SYS', 'SYSTEM', 'CTXSYS', 'MDSYS', 'DBSNMP', 'WMSYS', 'XDB', 'APEX_030200', 'FLOWS_FILES', 'HR', 'OE', 'PM', 'IX', 'SH', 'BI')
    AND v.OWNER NOT LIKE 'APEX_%'
    AND v.OWNER NOT LIKE 'FLOWS_%'
ORDER BY 
    table_schema, table_name
