--4.How many customer records look like data quality problems (e.g. missing contact details, duplicate identity)? 
--the count and what you count as a "problem".

--A. Count missing contact/customer information

USE dwh_customer360;
GO

SELECT
    COUNT(*) AS records_with_data_quality_problems

FROM dbo.dwh_dim_client

WHERE
       client_number IS NULL
    OR NULLIF(LTRIM(RTRIM(first_name)), '') IS NULL
    OR NULLIF(LTRIM(RTRIM(last_name)), '') IS NULL
    OR NULLIF(LTRIM(RTRIM(email)), '') IS NULL
    OR NULLIF(LTRIM(RTRIM(mobile_number)), '') IS NULL
    OR date_of_birth IS NULL;
GO

--B. Find duplicate customer identities in staging
USE stg_customer360;
GO

SELECT
    client_number,
    COUNT(*) AS number_of_records
FROM [dwh_customer360].[dbo].[dwh_fact_table]

WHERE client_number IS NOT NULL
  AND LTRIM(RTRIM(client_number)) <> ''

GROUP BY client_number

HAVING COUNT(*) > 1

ORDER BY number_of_records DESC;
GO


--C.Count how many customer identities are duplicated
USE stg_customer360;
GO

SELECT
    COUNT(*) AS duplicate_customer_identities
FROM
(
    SELECT
        LTRIM(RTRIM(client_number)) AS client_number

    FROM dbo.stg_customer360_raw

    WHERE client_number IS NOT NULL
      AND LTRIM(RTRIM(client_number)) <> ''

    GROUP BY LTRIM(RTRIM(client_number))

    HAVING COUNT(*) > 1
) AS duplicates;
GO

--D. Show all data-quality problems together
USE dwh_customer360;
GO

SELECT
    SUM(
        CASE
            WHEN client_number IS NULL THEN 1
            ELSE 0
        END
    ) AS missing_client_number,

    SUM(
        CASE
            WHEN first_name IS NULL THEN 1
            ELSE 0
        END
    ) AS missing_first_name,

    SUM(
        CASE
            WHEN last_name IS NULL THEN 1
            ELSE 0
        END
    ) AS missing_last_name,

    SUM(
        CASE
            WHEN email IS NULL THEN 1
            ELSE 0
        END
    ) AS missing_email,

    SUM(
        CASE
            WHEN mobile_number IS NULL THEN 1
            ELSE 0
        END
    ) AS missing_mobile_number,

    SUM(
        CASE
            WHEN date_of_birth IS NULL THEN 1
            ELSE 0
        END
    ) AS missing_date_of_birth

FROM dbo.dwh_dim_client;
GO

--A customer record is considered a data-quality problem if it has a missing client number, missing first or last name, missing contact information (email or mobile number), or missing date of birth.
--Duplicate customer identities are also considered data-quality problems and are checked using the client number in the staging data.