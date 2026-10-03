IF NOT EXISTS (
    SELECT name
    FROM sys.databases
    WHERE name = 'stg_customer360'
)
BEGIN
    CREATE DATABASE stg_customer360;
END;
GO