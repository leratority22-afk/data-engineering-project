--13. Which channel is most used for complaints specifically, versus other interaction types?

--A.Channel used most for complaints

SELECT TOP 1
    channel,
    COUNT(*) AS complaint_interactions
FROM  dwh_customer360.dbo.dwh_fact_table
WHERE interaction_type = 'Complaint'
  AND channel IS NOT NULL
GROUP BY channel
ORDER BY complaint_interactions DESC;

--B. Compare channels across all interaction types

SELECT
    interaction_type,
    channel,
    COUNT(*) AS interaction_count
FROM  dwh_customer360.dbo.dwh_fact_table
WHERE interaction_type IS NOT NULL
  AND channel IS NOT NULL
GROUP BY
    interaction_type,
    channel
ORDER BY
    interaction_type,
    interaction_count DESC;


--C. Compare complaints versus other interactions
SELECT
    CASE
        WHEN interaction_type = 'Complaint' THEN 'Complaint'
        ELSE 'Other Interaction'
    END AS interaction_group,
    channel,
    COUNT(*) AS interaction_count
FROM  dwh_customer360.dbo.dwh_fact_table
WHERE interaction_type IS NOT NULL
  AND channel IS NOT NULL
GROUP BY
    CASE
        WHEN interaction_type = 'Complaint' THEN 'Complaint'
        ELSE 'Other Interaction'
    END,
    channel
ORDER BY
    interaction_group,
    interaction_count DESC;


   -- show the percentage within each group
WITH ChannelCounts AS
(
    SELECT
        CASE
            WHEN interaction_type = 'Complaint' THEN 'Complaint'
            ELSE 'Other Interaction'
        END AS interaction_group,
        channel,
        COUNT(*) AS interaction_count
 FROM  dwh_customer360.dbo.dwh_fact_table
    WHERE interaction_type IS NOT NULL
      AND channel IS NOT NULL
    GROUP BY
        CASE
            WHEN interaction_type = 'Complaint' THEN 'Complaint'
            ELSE 'Other Interaction'
        END,
        channel
)
SELECT
    interaction_group,
    channel,
    interaction_count,
    CAST(
        interaction_count * 100.0 /
        SUM(interaction_count) OVER (PARTITION BY interaction_group)
        AS DECIMAL(10,2)
    ) AS percentage_of_group
FROM ChannelCounts
ORDER BY
    interaction_group,
    interaction_count DESC;


