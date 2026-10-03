
--8.What proportion of Credit Card accounts are within 90% of their credit limit?

  USE dwh_customer360;
GO

SELECT
    COUNT(*) AS credit_card_accounts,

    SUM(
        CASE
            WHEN account_balance >= credit_limit * 0.90
            THEN 1
            ELSE 0
        END
    ) AS accounts_within_90_percent,

    CAST(
        SUM(
            CASE
                WHEN account_balance >= credit_limit * 0.90
                THEN 1
                ELSE 0
            END
        ) * 100.0
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(5,2)
    ) AS percentage_within_90_percent

FROM [dwh_customer360].[dbo].[dwh_fact_table]

WHERE LOWER(LTRIM(RTRIM(product_type))) = 'credit card'
  AND credit_limit IS NOT NULL
  AND account_balance IS NOT NULL;
GO


