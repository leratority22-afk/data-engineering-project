USE stg_customer360;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.tables
    WHERE name = 'stg_dim_account'
      AND schema_id = SCHEMA_ID('dbo')
)
BEGIN
    CREATE TABLE dbo.stg_dim_account
    (
        account_number     NVARCHAR(50) NULL,
        product_type       NVARCHAR(100) NULL,
        account_status     NVARCHAR(100) NULL,
        credit_limit       DECIMAL(18,2) NULL,
        loan_amount        DECIMAL(18,2) NULL,
       
    );
END;
GO


USE stg_customer360;
GO

INSERT INTO dbo.stg_dim_account
(
    account_number
      ,product_type
      ,account_status
      ,credit_limit
      ,loan_amount
)
SELECT
    account_number
      ,s.product_type
      ,s.account_status
      ,s.credit_limit
      ,s.loan_amount
FROM [stg_customer360].[dbo].[stg_customer360_raw]AS s
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.stg_dim_account AS d
    WHERE d.account_number = s.account_number
);
GO
