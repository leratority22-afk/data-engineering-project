/*========================================================
  3. CREATE DWH FACT TABLE
========================================================*/

IF OBJECT_ID('dbo.dwh_fact_table', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.dwh_fact_table
    (
        fact_key            INT IDENTITY(1,1) PRIMARY KEY,

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
        event_date          DATE NULL,

        interaction_type    NVARCHAR(100) NULL,
        resolved_flag       BIT NULL,

        transaction_type    NVARCHAR(100) NULL,
        amount              DECIMAL(18,2) NULL,
        account_balance     DECIMAL(18,2) NULL
    );
END;
GO




/*========================================================
  4. LOAD AND CLEAN DATA FROM STAGING
     
   
========================================================*/

INSERT INTO dbo.dwh_fact_table
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
SELECT DISTINCT

    /* Client */
    NULLIF(LTRIM(RTRIM(s.client_number)), '') AS client_number,

    NULLIF(LTRIM(RTRIM(s.first_name)), '') AS first_name,

    NULLIF(LTRIM(RTRIM(s.last_name)), '') AS last_name,


    /* Account */
    NULLIF(LTRIM(RTRIM(s.account_number)), '') AS account_number,

    NULLIF(LTRIM(RTRIM(s.product_type)), '') AS product_type,

    NULLIF(LTRIM(RTRIM(s.account_status)), '') AS account_status,


    /* Location */
    NULLIF(LTRIM(RTRIM(s.province)), '') AS province,

    NULLIF(LTRIM(RTRIM(s.city)), '') AS city,


    /* Channel */
    NULLIF(LTRIM(RTRIM(s.channel)), '') AS channel,


    /* Event */
    NULLIF(LTRIM(RTRIM(s.event_type)), '') AS event_type,

    TRY_CONVERT(
        DATE,
        NULLIF(LTRIM(RTRIM(s.event_date)), '')
    ) AS event_date,


    /* Interaction */
    NULLIF(LTRIM(RTRIM(s.interaction_type)), '') AS interaction_type,

    CASE
        WHEN LOWER(LTRIM(RTRIM(s.resolved_flag)))
             IN ('1', 'true', 'yes', 'y')
            THEN 1

        WHEN LOWER(LTRIM(RTRIM(s.resolved_flag)))
             IN ('0', 'false', 'no', 'n')
            THEN 0

        ELSE NULL
    END AS resolved_flag,


    /* Transaction */
    NULLIF(LTRIM(RTRIM(s.transaction_type)), '') AS transaction_type,

    TRY_CONVERT(
        DECIMAL(18,2),
        NULLIF(LTRIM(RTRIM(s.amount)), '')
    ) AS amount,

    TRY_CONVERT(
        DECIMAL(18,2),
        NULLIF(LTRIM(RTRIM(s.account_balance)), '')
    ) AS account_balance


FROM stg_customer360.dbo.stg_fact_table AS s

WHERE
    /* Do not load completely empty records */
    (
        NULLIF(LTRIM(RTRIM(s.client_number)), '') IS NOT NULL
        OR
        NULLIF(LTRIM(RTRIM(s.account_number)), '') IS NOT NULL
        OR
        NULLIF(LTRIM(RTRIM(s.event_type)), '') IS NOT NULL
        OR
        NULLIF(LTRIM(RTRIM(s.interaction_type)), '') IS NOT NULL
        OR
        NULLIF(LTRIM(RTRIM(s.transaction_type)), '') IS NOT NULL
    )

    /* Prevent duplicate fact records */
    AND NOT EXISTS
    (
        SELECT 1
        FROM dbo.dwh_fact_table AS d
        WHERE
            ISNULL(d.client_number, '') =
            ISNULL(NULLIF(LTRIM(RTRIM(s.client_number)), ''), '')

        AND ISNULL(d.account_number, '') =
            ISNULL(NULLIF(LTRIM(RTRIM(s.account_number)), ''), '')

        AND ISNULL(d.event_type, '') =
            ISNULL(NULLIF(LTRIM(RTRIM(s.event_type)), ''), '')

        AND ISNULL(d.event_date, '19000101') =
            ISNULL(
                TRY_CONVERT(
                    DATE,
                    NULLIF(LTRIM(RTRIM(s.event_date)), '')
                ),
                '19000101'
            )

        AND ISNULL(d.interaction_type, '') =
            ISNULL(NULLIF(LTRIM(RTRIM(s.interaction_type)), ''), '')

        AND ISNULL(d.transaction_type, '') =
            ISNULL(NULLIF(LTRIM(RTRIM(s.transaction_type)), ''), '')

        AND ISNULL(d.amount, 0) =
            ISNULL(
                TRY_CONVERT(
                    DECIMAL(18,2),
                    NULLIF(LTRIM(RTRIM(s.amount)), '')
                ),
                0
            )

        AND ISNULL(d.account_balance, 0) =
            ISNULL(
                TRY_CONVERT(
                    DECIMAL(18,2),
                    NULLIF(LTRIM(RTRIM(s.account_balance)), '')
                ),
                0
            )
    );
GO


SELECT *
FROM dbo.dwh_fact_table
ORDER BY fact_key;
GO

