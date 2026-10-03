--14.What is the resolution rate (resolved_flag = Y) by channel? 
--Which channel resolves the least, and could that be sample-size noise rather than a real difference?

--Resolution rate by channel
SELECT
    channel,
    COUNT(*) AS total_interactions,
    SUM(
        CASE
            WHEN UPPER(LTRIM(RTRIM(resolved_flag))) = 'Y'
            THEN 1
            ELSE 0
        END
    ) AS resolved_interactions,
    CAST(
        SUM(
            CASE
                WHEN UPPER(LTRIM(RTRIM(resolved_flag))) = 'Y'
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*)
        AS DECIMAL(10,2)
    ) AS resolution_rate_percent
FROM  dwh_customer360.dbo.dwh_fact_table
WHERE channel IS NOT NULL
  AND interaction_type IS NOT NULL
GROUP BY channel
ORDER BY resolution_rate_percent DESC;

--Find the channel with the lowest resolution rate
SELECT TOP 1
    channel,
    COUNT(*) AS total_interactions,
    SUM(
        CASE
            WHEN UPPER(LTRIM(RTRIM(resolved_flag))) = 'Y'
            THEN 1
            ELSE 0
        END
    ) AS resolved_interactions,
    CAST(
        SUM(
            CASE
                WHEN UPPER(LTRIM(RTRIM(resolved_flag))) = 'Y'
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*)
        AS DECIMAL(10,2)
    ) AS resolution_rate_percent
FROM  dwh_customer360.dbo.dwh_fact_table
WHERE channel IS NOT NULL
  AND interaction_type IS NOT NULL
GROUP BY channel
ORDER BY resolution_rate_percent ASC;


--The resolution rate was calculated as the percentage of interactions with resolved_flag = 'Y' for each channel. 
--The channel with the lowest resolution rate should be interpreted alongside its number of interactions. 
--If the channel has a small sample size, its lower rate may be affected by random variation and may not represent a meaningful difference in the underlying resolution rate.