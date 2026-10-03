/*========================================================
  3. CREATE DIM_ACCOUNT
========================================================*/

IF OBJECT_ID('dbo.dwh_dim_account', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.dwh_dim_account
    (
        account_key      INT IDENTITY(1,1) PRIMARY KEY,

        account_number   NVARCHAR(50) NULL,
        product_type     NVARCHAR(100) NULL,
        account_status   NVARCHAR(100) NULL,
        credit_limit     DECIMAL(18,2) NULL,
        loan_amount      DECIMAL(18,2) NULL,

        CONSTRAINT UQ_dim_account
            UNIQUE (account_number)
    );
END;
GO


/*========================================================
  4. LOAD ACCOUNT DATA FROM STAGING
     
========================================================*/
INSERT INTO dbo.dwh_dim_account
(
    account_number,
    product_type,
    account_status,
    credit_limit,
    loan_amount
)
SELECT DISTINCT

    NULLIF(LTRIM(RTRIM(s.account_number)), '') AS account_number,

    NULLIF(LTRIM(RTRIM(s.product_type)), '') AS product_type,

    NULLIF(LTRIM(RTRIM(s.account_status)), '') AS account_status,

    TRY_CONVERT(
        DECIMAL(18,2),
        NULLIF(LTRIM(RTRIM(s.credit_limit)), '')
    ) AS credit_limit,

    TRY_CONVERT(
        DECIMAL(18,2),
        NULLIF(LTRIM(RTRIM(s.loan_amount)), '')
    ) AS loan_amount

FROM stg_customer360.dbo.stg_dim_account AS s

WHERE
    /* Do not load records without an account number */
    NULLIF(LTRIM(RTRIM(s.account_number)), '') IS NOT NULL

    /* Prevent duplicate accounts */
    AND NOT EXISTS
    (
        SELECT 1
        FROM dbo.dwh_dim_account AS d
        WHERE d.account_number =
              NULLIF(LTRIM(RTRIM(s.account_number)), '')
    );
GO

WITH src AS (
  SELECT
    account_number = NULLIF(LTRIM(RTRIM(s.account_number)), ''),
    product_type   = NULLIF(LTRIM(RTRIM(s.product_type)), ''),
    account_status = NULLIF(LTRIM(RTRIM(s.account_status)), ''),
    credit_limit   = TRY_CONVERT(DECIMAL(18,2), NULLIF(LTRIM(RTRIM(s.credit_limit)), '')),
    loan_amount    = TRY_CONVERT(DECIMAL(18,2), NULLIF(LTRIM(RTRIM(s.loan_amount)), '')),
    rn = ROW_NUMBER() OVER (
      PARTITION BY NULLIF(LTRIM(RTRIM(s.account_number)), '')
      ORDER BY (SELECT 0)  -- replace with meaningful ordering if available
    )
  FROM stg_customer360.dbo.stg_dim_account AS s
  WHERE NULLIF(LTRIM(RTRIM(s.account_number)), '') IS NOT NULL
)
INSERT INTO dwh_customer360.dbo.dwh_dim_account
(
  account_number,
  product_type,
  account_status,
  credit_limit,
  loan_amount
)
SELECT account_number, 
product_type, 
account_status, 
credit_limit, 
loan_amount
FROM src s
WHERE s.rn = 1
  AND NOT EXISTS (
    SELECT 1
    FROM dwh_customer360.dbo.dwh_dim_account d
    WHERE d.account_number = s.account_number
  );


