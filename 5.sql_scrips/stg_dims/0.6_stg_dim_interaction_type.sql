USE stg_customer360;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.tables
    WHERE name = 'stg_dim_interaction_type'
      AND schema_id = SCHEMA_ID('dbo')
)
BEGIN
    CREATE TABLE dbo.stg_dim_interaction_type
    (
      interaction_type   NVARCHAR(100) NULL,
    );
END;
GO




USE stg_customer360;
GO

INSERT INTO dbo.stg_dim_interaction_type
(
    interaction_type
)
SELECT

   s.interaction_type
FROM [stg_customer360].[dbo].[stg_customer360_raw]AS s
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.stg_dim_interaction_type AS d
    WHERE d.interaction_type = s.interaction_type
);
GO