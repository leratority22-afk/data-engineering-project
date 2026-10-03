--5. How many customers hold each product type, and how many hold more than one product?

USE dwh_customer360;
GO

SELECT
    product_type,
    COUNT(DISTINCT client_number) AS customer_count
FROM [dwh_customer360].[dbo].[dwh_fact_table]
WHERE client_number IS NOT NULL
  AND product_type IS NOT NULL
GROUP BY product_type
ORDER BY customer_count DESC;
GO

--Customers holding more than one product
--This counts customers who have 2 or more different product types.
USE dwh_customer360;
GO

SELECT
    COUNT(*) AS customers_with_more_than_one_product
FROM
(
    SELECT
        client_number
    FROM dbo.dwh_fact_table
    WHERE client_number IS NOT NULL
      AND product_type IS NOT NULL
    GROUP BY client_number
    HAVING COUNT(DISTINCT product_type) > 1
) AS cross_holding;
GO
