--10.Which transaction channel handles the most transactions, and which handles the highest total value?
--(These may not be the same channel, explain why, if so.)


--A. Transactions by channel
SELECT
    channel,
    COUNT(*) AS transaction_count,
    SUM(TRY_CONVERT(DECIMAL(18,2), amount)) AS total_transaction_value
FROM dwh_customer360.dbo.dwh_fact_table
WHERE channel IS NOT NULL
  AND transaction_type IS NOT NULL
GROUP BY channel
ORDER BY transaction_count DESC;

--B.Channel with the most transactions

SELECT TOP 1
    channel,
    COUNT(*) AS transaction_count
 FROM dwh_customer360.dbo.dwh_fact_table
WHERE channel IS NOT NULL
  AND transaction_type IS NOT NULL
GROUP BY channel
ORDER BY transaction_count DESC;

--C. Channel with the highest total transaction value

SELECT TOP 1
    channel,
    SUM(TRY_CONVERT(DECIMAL(18,2), amount)) AS total_transaction_value
 FROM dwh_customer360.dbo.dwh_fact_table
WHERE channel IS NOT NULL
  AND transaction_type IS NOT NULL
GROUP BY channel
ORDER BY total_transaction_value DESC;


