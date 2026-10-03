--17. Build a simple customer lifecycle segmentation (e.g. New / Active / At risk / Dormant) using signup date and activity recency. 
--State your thresholds and justify them.Report the customer count per segment.

WITH LatestDate AS
(
    SELECT MAX(event_date) AS latest_date
   FROM  dwh_customer360.dbo.dwh_fact_table
    WHERE event_date IS NOT NULL
),
CustomerActivity AS
(
    SELECT
        client_number,
        MAX(event_date) AS last_activity_date
    FROM  dwh_customer360.dbo.dwh_fact_table
    WHERE client_number IS NOT NULL
      AND event_date IS NOT NULL
    GROUP BY client_number
)
SELECT
    CASE
        WHEN last_activity_date >= DATEADD(DAY, -90, latest_date)
            THEN 'Active'

        WHEN last_activity_date >= DATEADD(DAY, -180, latest_date)
            THEN 'At Risk'

        ELSE 'Dormant'
    END AS lifecycle_segment,
    COUNT(*) AS customer_count
FROM CustomerActivity
CROSS JOIN LatestDate
GROUP BY
    CASE
        WHEN last_activity_date >= DATEADD(DAY, -90, latest_date)
            THEN 'Active'
        WHEN last_activity_date >= DATEADD(DAY, -180, latest_date)
            THEN 'At Risk'
        ELSE 'Dormant'
    END
ORDER BY
    CASE
        WHEN
            CASE
                WHEN last_activity_date >= DATEADD(DAY, -90, latest_date)
                    THEN 'Active'
                WHEN last_activity_date >= DATEADD(DAY, -180, latest_date)
                    THEN 'At Risk'
                ELSE 'Dormant'
            END = 'Active' THEN 1
        WHEN
            CASE
                WHEN last_activity_date >= DATEADD(DAY, -90, latest_date)
                    THEN 'Active'
                WHEN last_activity_date >= DATEADD(DAY, -180, latest_date)
                    THEN 'At Risk'
                ELSE 'Dormant'
            END = 'At Risk' THEN 2
        ELSE 3
    END

--New customers are defined as customers who signed up within the last 90 days.
--Active customers have had activity within the last 90 days but are not classified as New. 
--Customers with no activity for 91–180 days are classified as At Risk, while customers with no activity for more than 180 days are classified as Dormant.
--The 90-day and 180-day thresholds provide simple, consistent periods for distinguishing recent engagement from declining and long-term inactivity.
--The latest date in the dataset is used as the reference point because the data is a static extract.