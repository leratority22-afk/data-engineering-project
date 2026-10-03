

--2.What is the age distribution of the customer base? Present it in age bands of your own choosing and justify the bands.
  SELECT
    CASE
        WHEN age BETWEEN 18 AND 24 THEN '18-24'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        WHEN age BETWEEN 55 AND 64 THEN '55-64'
        WHEN age >= 65 THEN '65+'
        ELSE 'Under 18 / Invalid'
    END AS age_band,
    COUNT(*) AS customer_count
FROM
(
    SELECT DISTINCT
        client_number,
        DATEDIFF(YEAR, date_of_birth, GETDATE())
        -
        CASE
            WHEN DATEADD(
                YEAR,
                DATEDIFF(YEAR, date_of_birth, GETDATE()),
                date_of_birth
            ) > GETDATE()
            THEN 1
            ELSE 0
        END AS age
    FROM dbo.dwh_dim_client
    WHERE date_of_birth IS NOT NULL
) AS customers
GROUP BY
    CASE
        WHEN age BETWEEN 18 AND 24 THEN '18-24'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        WHEN age BETWEEN 55 AND 64 THEN '55-64'
        WHEN age >= 65 THEN '65+'
        ELSE 'Under 18 / Invalid'
    END;
GO