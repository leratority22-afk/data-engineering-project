--13. What is the average number of interactions per customer, split by interaction type?

SELECT
    interaction_type,
    COUNT(*) AS total_interactions,
    COUNT(DISTINCT client_number) AS customers,
    CAST(COUNT(*) * 1.0 / COUNT(DISTINCT client_number) AS DECIMAL(10,2))
        AS average_interactions_per_customer
FROM  dwh_customer360.dbo.dwh_fact_table
WHERE interaction_type IS NOT NULL
  AND client_number IS NOT NULL
GROUP BY interaction_type
ORDER BY average_interactions_per_customer DESC;


