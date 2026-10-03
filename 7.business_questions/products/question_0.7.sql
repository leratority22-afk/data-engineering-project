--7.Which customers hold a Savings account but no Credit Card? Report the count, this is a cross-sell list.

USE dwh_customer360;
GO

SELECT
    client_number,
    first_name,
    last_name
    FROM [dwh_customer360].[dbo].[dwh_fact_table]
WHERE client_number IS NOT NULL

GROUP BY
    client_number,
    first_name,
    last_name

HAVING
    SUM(
        CASE
            WHEN LOWER(LTRIM(RTRIM(product_type))) = 'savings'
            THEN 1
            ELSE 0
        END
    ) > 0

    AND

    SUM(
        CASE
            WHEN LOWER(LTRIM(RTRIM(product_type))) = 'credit card'
            THEN 1
            ELSE 0
        END
    ) = 0

ORDER BY client_number;
GO

--count only
USE dwh_customer360;
GO

SELECT
    COUNT(*) AS savings_without_credit_card
FROM
(
    SELECT
        client_number
    FROM dbo.dwh_fact_table

    WHERE client_number IS NOT NULL

    GROUP BY client_number

    HAVING
        SUM(
            CASE
                WHEN LOWER(LTRIM(RTRIM(product_type))) = 'savings'
                THEN 1
                ELSE 0
            END
        ) > 0

        AND

        SUM(
            CASE
                WHEN LOWER(LTRIM(RTRIM(product_type))) = 'credit card'
                THEN 1
                ELSE 0
            END
        ) = 0
) AS cross_sell;
GO