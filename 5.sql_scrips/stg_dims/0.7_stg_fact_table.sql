/*========================================================
  CREATE STAGING FACT TABLE
  NO DATA CLEANING
========================================================*/

USE stg_customer360;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.tables
    WHERE name = 'stg_fact_table'
      AND schema_id = SCHEMA_ID('dbo')
)
BEGIN
    CREATE TABLE dbo.stg_fact_table
    (
        client_number       NVARCHAR(50) NULL,
        first_name          NVARCHAR(100) NULL,
        last_name           NVARCHAR(100) NULL,

        account_number      NVARCHAR(50) NULL,
        product_type        NVARCHAR(100) NULL,
        account_status      NVARCHAR(100) NULL,

        province            NVARCHAR(100) NULL,
        city                NVARCHAR(100) NULL,

        channel             NVARCHAR(100) NULL,

        event_type          NVARCHAR(100) NULL,
        event_date          NVARCHAR(100) NULL,

        interaction_type    NVARCHAR(100) NULL,
        resolved_flag       NVARCHAR(100) NULL,

        transaction_type    NVARCHAR(100) NULL,
        amount              NVARCHAR(100) NULL,
        account_balance     NVARCHAR(100) NULL
    );
END;
GO


/*========================================================
  LOAD STAGING FACT TABLE
  NO CLEANING
========================================================*/

USE stg_customer360;
GO

INSERT INTO dbo.stg_fact_table
(
    client_number,
    first_name,
    last_name,
    account_number,
    product_type,
    account_status,
    province,
    city,
    channel,
    event_type,
    event_date,
    interaction_type,
    resolved_flag,
    transaction_type,
    amount,
    account_balance
)
SELECT
    s.client_number,
    s.first_name,
    s.last_name,
    s.account_number,
    s.product_type,
    s.account_status,
    s.province,
    s.city,
    s.channel,
    s.event_type,
    s.event_date,
    s.interaction_type,
    s.resolved_flag,
    s.transaction_type,
    s.amount,
    s.account_balance

FROM dbo.stg_customer360_raw AS s;
GO