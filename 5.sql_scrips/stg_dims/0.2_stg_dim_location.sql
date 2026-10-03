USE stg_customer360;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.tables
    WHERE name = 'stg_dim_location'
      AND schema_id = SCHEMA_ID('dbo')
)
BEGIN
    CREATE TABLE dbo.stg_dim_location
    (
        province           NVARCHAR(100) NULL,
        city               NVARCHAR(100) NULL,
                 
    );
END;
GO

USE stg_customer360;
GO

INSERT INTO dbo.stg_dim_location
(
    province
      ,city
)
SELECT
   s.province
      ,s.city
FROM [stg_customer360].[dbo].[stg_customer360_raw]AS s
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.stg_dim_location AS d
    WHERE d.province = s.province
);
GO
