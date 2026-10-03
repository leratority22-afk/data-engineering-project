--16. Is there a relationship between number of CRM interactions and transaction value? 
--(A simple grouped comparison is enough, this is not a statistics course.)

WITH CustomerSummary AS
(
    SELECT
        client_number,

        COUNT(
            CASE
                WHEN interaction_type IS NOT NULL
                THEN 1
            END
        ) AS interaction_count,

        SUM(
            CASE
                WHEN transaction_type IS NOT NULL
                THEN TRY_CONVERT(DECIMAL(18,2), amount)
                ELSE 0
            END
        ) AS total_transaction_value

       FROM  dwh_customer360.dbo.dwh_fact_table
    WHERE client_number IS NOT NULL
    GROUP BY client_number
),
InteractionGroups AS
(
    SELECT
        client_number,
        interaction_count,
        total_transaction_value,

        CASE
            WHEN interaction_count = 0 THEN '0 interactions'
            WHEN interaction_count BETWEEN 1 AND 2 THEN '1-2 interactions'
            WHEN interaction_count BETWEEN 3 AND 5 THEN '3-5 interactions'
            ELSE '6+ interactions'
        END AS interaction_group

    FROM CustomerSummary
)
SELECT
    interaction_group,
    COUNT(*) AS customer_count,
    SUM(total_transaction_value) AS total_transaction_value,
    AVG(total_transaction_value) AS average_transaction_value
FROM InteractionGroups
GROUP BY interaction_group
ORDER BY
    CASE interaction_group
        WHEN '0 interactions' THEN 1
        WHEN '1-2 interactions' THEN 2
        WHEN '3-5 interactions' THEN 3
        WHEN '6+ interactions' THEN 4
    END;

--Customers were grouped according to the number of CRM interactions they had: 0, 1–2, 3–5, and 6 or more interactions.
--Total and average transaction value were then compared across the groups. 
--If customers with more interactions have consistently higher average transaction values, this suggests an association between CRM engagement and transaction value.
--However, this grouped comparison does not establish that CRM interactions cause higher transaction values.
