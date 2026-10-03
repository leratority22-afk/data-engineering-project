USE stg_customer360;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.tables
    WHERE name = 'stg_dim_event_type'
      AND schema_id = SCHEMA_ID('dbo')
)
BEGIN
    CREATE TABLE dbo.stg_dim_event_type
    (
         event_type         NVARCHAR(100) NULL,
        event_date         DATE NULL,
      
    );
END;
GO

USE stg_customer360;
GO

INSERT INTO dbo.stg_dim_event_type
(
   event_type
      ,event_date
)
SELECT
  s.event_type
      ,s.event_date
FROM [stg_customer360].[dbo].[stg_customer360_raw]AS s
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.stg_dim_event_type AS d
    WHERE d.event_type = s.event_type
);
GO
