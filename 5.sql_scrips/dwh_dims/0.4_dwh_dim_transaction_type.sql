/*========================================================
  3. CREATE DIM_TRANSACTION_TYPE
========================================================*/

IF OBJECT_ID('dbo.dwh_dim_transaction_type', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.dwh_dim_transaction_type
    (
        transaction_type_key INT IDENTITY(1,1) PRIMARY KEY,

        transaction_type NVARCHAR(100) NULL,

        CONSTRAINT UQ_dim_transaction_type
            UNIQUE (transaction_type)
    );
END;
GO




/*========================================================
  4. LOAD TRANSACTION TYPE FROM STAGING
    
========================================================*/

INSERT INTO dbo.dwh_dim_transaction_type
(
    transaction_type
)
SELECT DISTINCT

    NULLIF(
        LTRIM(RTRIM(s.transaction_type)),
        ''
    ) AS transaction_type

FROM stg_customer360.dbo.stg_dim_transaction_type AS s

WHERE
    /* Do not load blank transaction types */
    NULLIF(
        LTRIM(RTRIM(s.transaction_type)),
        ''
    ) IS NOT NULL

    /* Prevent duplicate transaction types */
    AND NOT EXISTS
    (
        SELECT 1
        FROM dbo.dwh_dim_transaction_type AS d
        WHERE d.transaction_type =
              NULLIF(
                  LTRIM(RTRIM(s.transaction_type)),
                  ''
              )
    );
GO