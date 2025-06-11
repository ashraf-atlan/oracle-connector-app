/*
 * File: filter_metadata.sql
 * Purpose: Retrieves basic schema information for metadata filtering in Oracle Database
 *
 * This query returns a list of schema names from the current Oracle database,
 * excluding system schemas and locked accounts. Used for initial metadata discovery and filtering.
 *
 * Returns:
 *   - schema_name: Username/schema name
 *   - catalog_name: Database name from system context
 *   - account_status: Status of the user account
 *   - created: When the schema was created
 *
 * Notes:
 *   - Excludes Oracle system schemas and service accounts
 *   - Only includes schemas with OPEN account status
 *   - Ordered alphabetically by schema name
 */
SELECT 
    u.username AS schema_name,
    SYS_CONTEXT('USERENV', 'DB_NAME') AS catalog_name,
    u.account_status,
    u.created
FROM 
    DBA_USERS u
WHERE 
    u.username NOT IN (
        'SYS', 'SYSTEM', 'DBSNMP', 'SYSMAN', 'OUTLN', 'FLOWS_FILES', 
        'MDSYS', 'ORDSYS', 'EXFSYS', 'WMSYS', 'APPQOSSYS', 'APEX_030200', 
        'APEX_PUBLIC_USER', 'FLOWS_030100', 'OWBSYS', 'OWBSYS_AUDIT', 
        'SCOTT', 'XDB', 'ANONYMOUS', 'CTXSYS', 'DVF', 'DVSYS', 
        'DBSFWUSER', 'OJVMSYS', 'ORDPLUGINS', 'ORDDATA', 'SI_INFORMTN_SCHEMA', 
        'OLAPSYS', 'MDDATA', 'SPATIAL_CSW_ADMIN_USR', 'SPATIAL_WFS_ADMIN_USR', 
        'LBACSYS', 'AUDSYS', 'DIP', 'GSMADMIN_INTERNAL', 'GSMCATUSER', 
        'GSMUSER', 'SYSBACKUP', 'SYSDG', 'SYSKM', 'SYSRAC', 'SYS$UMF', 
        'PDBADMIN', 'GGSYS', 'REMOTE_SCHEDULER_AGENT', 'DBMS_SFW_ACL_ADMIN'
    )
    AND u.account_status = 'OPEN'
    AND u.username NOT LIKE 'APEX_%'
    AND u.username NOT LIKE 'FLOWS_%'
    AND u.username NOT LIKE 'HR%'
    AND u.username NOT LIKE 'OE%'
    AND u.username NOT LIKE 'PM%'
    AND u.username NOT LIKE 'IX%'
    AND u.username NOT LIKE 'SH%'
    AND u.username NOT LIKE 'BI%'
ORDER BY 
    u.username