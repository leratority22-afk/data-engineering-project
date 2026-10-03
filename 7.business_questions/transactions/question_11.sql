--11.Define "active customer" using transaction and/or interaction recency, state your definition,
--and report how many customers are active vs not, as of the latest date in the data.

WITH LatestDate AS
(
    SELECT MAX(event_date) AS latest_date
     FROM dwh_customer360.dbo.dwh_fact_table
    WHERE event_date IS NOT NULL
),
CustomerActivity AS
(
    SELECT
        client_number,
        MAX(event_date) AS last_activity_date
     FROM dwh_customer360.dbo.dwh_fact_table
    WHERE client_number IS NOT NULL
      AND event_date IS NOT NULL
      AND (
            transaction_type IS NOT NULL
            OR interaction_type IS NOT NULL
          )
    GROUP BY client_number
)
SELECT
    CASE
        WHEN ca.last_activity_date >= DATEADD(DAY, -90, ld.latest_date)
            THEN 'Active'
        ELSE 'Not Active'
    END AS customer_status,
    COUNT(*) AS customer_count
FROM CustomerActivity ca
CROSS JOIN LatestDate ld
GROUP BY
    CASE
        WHEN ca.last_activity_date >= DATEADD(DAY, -90, ld.latest_date)
            THEN 'Active'
        ELSE 'Not Active'
    END
ORDER BY customer_status;


--B.the latest date used
SELECT MAX(event_date) AS latest_date
   FROM dwh_customer360.dbo.dwh_fact_table


--C. Showing each customer's status

WITH LatestDate AS
(
    SELECT MAX(event_date) AS latest_date
 FROM [stg_customer360].[dbo].[stg_customer360_raw]
    WHERE event_date IS NOT NULL
),
CustomerActivity AS
(
    SELECT
        client_number,
        MAX(event_date) AS last_activity_date
   FROM [stg_customer360].[dbo].[stg_customer360_raw]
    WHERE client_number IS NOT NULL
      AND event_date IS NOT NULL
      AND (
            transaction_type IS NOT NULL
            OR interaction_type IS NOT NULL
          )
    GROUP BY client_number
)
SELECT
    ca.client_number,
    ca.last_activity_date,
    ld.latest_date,
    CASE
        WHEN ca.last_activity_date >= DATEADD(DAY, -90, ld.latest_date)
            THEN 'Active'
        ELSE 'Not Active'
    END AS customer_status
FROM CustomerActivity ca
CROSS JOIN LatestDate ld
ORDER BY ca.last_activity_date DESC;