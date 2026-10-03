
---1.How many customers does the bank have per province, and what share of the total does each province represent?
USE dwh_customer360;
GO

SELECT
    province,
    COUNT(DISTINCT client_number) AS customer_count,

    CAST(
        COUNT(DISTINCT client_number) * 100.0
        / NULLIF(
            (
                SELECT COUNT(DISTINCT client_number)
                FROM dbo.dwh_fact_table
                WHERE province IS NOT NULL
                  AND client_number IS NOT NULL
            ),
            0
        )
        AS DECIMAL(5,2)
    ) AS percentage_of_total

FROM [dwh_customer360].[dbo].[dwh_fact_table]

WHERE province IS NOT NULL
  AND client_number IS NOT NULL

GROUP BY province
ORDER BY customer_count DESC;
GO




