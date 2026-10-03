--16.Segment customers into a small number of value tiers based on transaction activity (your choice of method, quartiles, fixed thresholds, etc.).
--Report the customer count and total transaction value per tier.

WITH CustomerTotals AS
(
    SELECT
        client_number,
        SUM(TRY_CONVERT(DECIMAL(18,2), amount)) AS total_transaction_value
   FROM  dwh_customer360.dbo.dwh_fact_table
    WHERE client_number IS NOT NULL
      AND transaction_type IS NOT NULL
      AND amount IS NOT NULL
    GROUP BY client_number
),
CustomerTiers AS
(
    SELECT
        client_number,
        total_transaction_value,
        NTILE(4) OVER (
            ORDER BY total_transaction_value
        ) AS value_tier
    FROM CustomerTotals
)
SELECT
    value_tier,
    CASE value_tier
        WHEN 1 THEN 'Low Value'
        WHEN 2 THEN 'Lower-Mid Value'
        WHEN 3 THEN 'Upper-Mid Value'
        WHEN 4 THEN 'High Value'
    END AS tier_name,
    COUNT(*) AS customer_count,
    SUM(total_transaction_value) AS total_transaction_value
FROM CustomerTiers
GROUP BY value_tier
ORDER BY value_tier;



--Customers were segmented into four value tiers using quartiles based on their total transaction value. 
--Tier 1 represents customers with the lowest transaction activity, while Tier 4 represents customers with the highest transaction activity.
--The customer count and total transaction value were then calculated for each tier. 
--This approach provides an even distribution of customers across the four groups while showing how transaction value is distributed between lower- and higher-value customers.
