USE stg_customer360;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.tables
    WHERE name = 'stg_dim_channel'
      AND schema_id = SCHEMA_ID('dbo')
)
BEGIN
    CREATE TABLE dbo.stg_dim_transaction_type
    (
        channel   NVARCHAR(100) NULL,
      transaction_type   NVARCHAR(100) NULL,
    );
END;
GO

USE stg_customer360;
GO

INSERT INTO dbo.stg_dim_transaction_type
(
    channel,
    transaction_type
)
SELECT
   s. channel,
   s.transaction_type
FROM [stg_customer360].[dbo].[stg_customer360_raw]AS s
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.stg_dim_transaction_type AS d
    WHERE d.channel = s.channel
);
GO
