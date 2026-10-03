--9.What is total transaction value by month, split by transaction type? Are there seasonal patterns?

SELECT
    YEAR(event_date) AS transaction_year,
    MONTH(event_date) AS transaction_month,
    DATENAME(MONTH, event_date) AS month_name,
    transaction_type,
    SUM(TRY_CONVERT(DECIMAL(18,2), amount)) AS total_transaction_value
  FROM dwh_customer360.dbo.dwh_fact_table
WHERE transaction_type IS NOT NULL
  AND amount IS NOT NULL
  AND event_date IS NOT NULL
GROUP BY
    YEAR(event_date),
    MONTH(event_date),
    DATENAME(MONTH, event_date),
    transaction_type
ORDER BY
    transaction_year,
    transaction_month,
    transaction_type;


--To see the seasonal pattern

SELECT
    MONTH(event_date) AS transaction_month,
    DATENAME(MONTH, event_date) AS month_name,
    SUM(TRY_CONVERT(DECIMAL(18,2), amount)) AS total_transaction_value
  FROM dwh_customer360.dbo.dwh_fact_table
WHERE event_date IS NOT NULL
  AND amount IS NOT NULL
  AND transaction_type IS NOT NULL
GROUP BY
    MONTH(event_date),
    DATENAME(MONTH, event_date)
ORDER BY
    transaction_month;
