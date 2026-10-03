
--12. Who are the top 20 customers by total transaction value in the last 12 months of data?
--(Use the latest transaction date in the data as your reference point, not today's date, this is a static extract.)

WITH LatestTransactionDate AS
(
    SELECT MAX(event_date) AS latest_transaction_date
    FROM dwh_customer360.dbo.dwh_fact_table
    WHERE transaction_type IS NOT NULL
      AND amount IS NOT NULL
      AND event_date IS NOT NULL
),
CustomerTotals AS
(
    SELECT
        s.client_number,
        MAX(s.first_name) AS first_name,
        MAX(s.last_name) AS last_name,
        SUM(TRY_CONVERT(DECIMAL(18,2), s.amount)) AS total_transaction_value
    FROM  dwh_customer360.dbo.dwh_fact_table s
    CROSS JOIN LatestTransactionDate l
    WHERE s.transaction_type IS NOT NULL
      AND s.amount IS NOT NULL
      AND s.event_date IS NOT NULL
      AND s.event_date >= DATEADD(MONTH, -12, l.latest_transaction_date)
      AND s.event_date <= l.latest_transaction_date
    GROUP BY
        s.client_number
)
SELECT TOP 20
    client_number,
    first_name,
    last_name,
    total_transaction_value
FROM CustomerTotals
ORDER BY total_transaction_value DESC;



--showing the reference dates
-- to verify the period being used
SELECT
    MAX(event_date) AS latest_transaction_date,
    DATEADD(MONTH, -12, MAX(event_date)) AS start_of_12_month_period
    FROM  dwh_customer360.dbo.dwh_fact_table
WHERE transaction_type IS NOT NULL
  AND amount IS NOT NULL
  AND event_date IS NOT NULL;