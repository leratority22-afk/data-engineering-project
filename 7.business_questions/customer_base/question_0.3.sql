--3.How many customers have signed up per month over the last two years? Is signup growth trending up, flat, or down?


  SELECT
    DATEFROMPARTS(
        YEAR(signup_date),
        MONTH(signup_date),
        1
    ) AS signup_month,

    COUNT(DISTINCT client_number) AS customer_signups

FROM dbo.dwh_dim_client

WHERE signup_date >= DATEADD(YEAR, -2, CAST(GETDATE() AS DATE))
  AND signup_date <= CAST(GETDATE() AS DATE)

GROUP BY
    DATEFROMPARTS(
        YEAR(signup_date),
        MONTH(signup_date),
        1
    )

ORDER BY signup_month;
GO