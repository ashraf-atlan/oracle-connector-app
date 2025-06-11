/*
 * File: tables_check.sql
 * Purpose: Counts accessible tables matching filter criteria
 *
 * Parameters:
 *   {normalized_exclude_regex} - Regex pattern for schemas to exclude
 *   {normalized_include_regex} - Regex pattern for schemas to include
 *   {temp_table_regex_sql} - Optional SQL for filtering temporary tables
 *
 * Returns: Count of tables/views matching the specified criteria
 *
 * Notes:
 *   - Used for validation and performance estimation
 *   - Includes only tables of types: 'r','p','v','m','f' (regular, partitioned, view, materialized view, foreign)
 *   - Excludes system schemas
 */
SELECT 1 as count
FROM (
    SELECT t.owner AS schema_name, t.table_name AS object_name
    FROM all_tables t
    WHERE t.owner NOT IN ('SYS', 'SYSTEM', 'OUTLN', 'CTXSYS', 'DBSNMP', 'ORDDATA', 'ORDSYS', 'MDSYS')
    UNION ALL
    SELECT v.owner AS schema_name, v.view_name AS object_name
    FROM all_views v
    WHERE v.owner NOT IN ('SYS', 'SYSTEM', 'OUTLN', 'CTXSYS', 'DBSNMP', 'ORDDATA', 'ORDSYS', 'MDSYS')
)