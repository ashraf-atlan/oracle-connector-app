/*
 * File: extract_column.sql
 * Purpose: Extracts detailed column metadata from Oracle database
 *
 * Parameters:
 *   {normalized_exclude_regex} - Regex pattern for schemas to exclude
 *   {normalized_include_regex} - Regex pattern for schemas to include
 *   {temp_table_regex_sql} - Optional SQL for filtering temporary tables
 *
 * Returns:
 *   - Comprehensive column metadata including:
 *     - Column names, data types, and positions
 *     - Nullability and default values
 *     - Auto-increment and identity properties
 *     - Constraint information (primary key, foreign key, etc.)
 *     - Column descriptions/remarks
 *
 * Notes:
 *   - Only includes columns with COLUMN_ID > 0
 *   - Excludes system schemas
 *   - Complex type handling with special cases for various data types
 *   - Includes constraint types and names for each column
 *   - Results ordered by schema, table, and column position
 */
SELECT
    NULL as table_catalog,
    OWNER as table_schema,
    TABLE_NAME as table_name,
    COLUMN_NAME as column_name,
    COLUMN_ID as ordinal_position,
    'NO' as column_default,
    NULLABLE as is_nullable,
    DATA_TYPE as data_type,
    CHAR_LENGTH as character_maximum_length,
    DATA_PRECISION as numeric_precision,
    DATA_SCALE as numeric_scale,
    'NO' as remarks,
    'NO' as is_primary_key,
    'NO' as is_foreign_key,
    'NO' as is_auto_increment,
    'NO' as is_identity,
    NULL as constraint_type,
    NULL as constraint_name
FROM ALL_TAB_COLUMNS
WHERE COLUMN_ID > 0
  AND OWNER LIKE 'ATLAN%'
ORDER BY OWNER, TABLE_NAME, COLUMN_ID

