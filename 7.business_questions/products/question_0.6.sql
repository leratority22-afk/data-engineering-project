--6.What is the total and average account balance by product type?

SELECT
    product_type,

    CAST(SUM(account_balance) AS DECIMAL(18,2))
        AS total_account_balance,

    CAST(AVG(account_balance) AS DECIMAL(18,2))
        AS average_account_balance

FROM [dwh_customer360].[dbo].[dwh_fact_table]

WHERE product_type IS NOT NULL
  AND account_balance IS NOT NULL

GROUP BY product_type

ORDER BY product_type;
GO

