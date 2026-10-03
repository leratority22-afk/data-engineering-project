--Build a month-over-month retention view: of customers active in month N,
--what percentage were still active in month N+1?

WITH MonthlyActiveCustomers AS
(
    SELECT DISTINCT
        client_number,
        YEAR(event_date) AS activity_year,
        MONTH(event_date) AS activity_month
     FROM  dwh_customer360.dbo.dwh_fact_table
    WHERE client_number IS NOT NULL
      AND event_date IS NOT NULL
      AND (
            transaction_type IS NOT NULL
            OR interaction_type IS NOT NULL
          )
),
MonthRetention AS
(
    SELECT
        a.activity_year,
        a.activity_month,
        COUNT(*) AS active_customers,
        COUNT(b.client_number) AS retained_customers
    FROM MonthlyActiveCustomers a
    LEFT JOIN MonthlyActiveCustomers b
        ON a.client_number = b.client_number
        AND DATEFROMPARTS(b.activity_year, b.activity_month, 1)
            = DATEADD(
                MONTH,
                1,
                DATEFROMPARTS(a.activity_year, a.activity_month, 1)
            )
    GROUP BY
        a.activity_year,
        a.activity_month
)
SELECT
    activity_year,
    activity_month,
    active_customers,
    retained_customers,
    CAST(
        retained_customers * 100.0 / NULLIF(active_customers, 0)
        AS DECIMAL(10,2)
    ) AS retention_rate_percent
FROM MonthRetention
ORDER BY
    activity_year,
    activity_month;


   -- Month-over-month retention measures how many customers who were active in one month remained active in the following month.
   --A higher retention percentage indicates that a larger share of the previous month's active customers continued to use the bank's services in the next month.
   --The calculation uses the customer's event_date and considers a customer active if they had either a transaction or CRM interaction during the month.

--Note: The final month in your dataset cannot have an N+1 retention percentage because there is no following month to compare against.