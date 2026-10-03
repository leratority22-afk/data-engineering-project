USE stg_customer360;
GO

-- Create staging schema
IF NOT EXISTS
(
    SELECT 1
    FROM sys.schemas
    WHERE name = 'stg_customer360'
)
BEGIN
    EXEC('CREATE SCHEMA stg_customer360 ');
END;
GO

-- Create data warehouse schema
IF NOT EXISTS
(
    SELECT 1
    FROM sys.schemas
    WHERE name = 'dwh_customer360'
)
BEGIN
    EXEC('CREATE SCHEMA dwh_customer360');
END;
GO