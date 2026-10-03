--19. Identify accounts with unusual transaction patterns (e.g. a sudden spike relative to the account's own history) 
--and explain what additional data you'd want to confirm whether it's fraud.

WITH AccountHistory AS
(
    SELECT
        account_number,
        AVG(TRY_CONVERT(DECIMAL(18,2), amount)) AS average_transaction_amount,
        MAX(TRY_CONVERT(DECIMAL(18,2), amount)) AS highest_transaction_amount,
        COUNT(*) AS transaction_count
    FROM  dwh_customer360.dbo.dwh_fact_table
    WHERE account_number IS NOT NULL
      AND transaction_type IS NOT NULL
      AND amount IS NOT NULL
    GROUP BY account_number
),
UnusualTransactions AS
(
    SELECT
        s.client_number,
        s.account_number,
        s.event_date,
        s.transaction_type,
        TRY_CONVERT(DECIMAL(18,2), s.amount) AS transaction_amount,
        h.average_transaction_amount,
        h.transaction_count
     FROM  dwh_customer360.dbo.dwh_fact_table s
    INNER JOIN AccountHistory h
        ON s.account_number = h.account_number
    WHERE s.transaction_type IS NOT NULL
      AND s.amount IS NOT NULL
      AND TRY_CONVERT(DECIMAL(18,2), s.amount)
          > h.average_transaction_amount * 3
)
SELECT
    client_number,
    account_number,
    event_date,
    transaction_type,
    transaction_amount,
    average_transaction_amount,
    transaction_count,
    CAST(
        transaction_amount / NULLIF(average_transaction_amount, 0)
        AS DECIMAL(10,2)
    ) AS times_above_average
FROM UnusualTransactions
ORDER BY
    times_above_average DESC;

--Unusual transactions can be identified by comparing each transaction with the account's own historical behaviour.
--In this analysis, transactions more than three times the account's average transaction value are flagged as unusual. 
--device details, login activity, merchant information and authentication records would be required to investigate whether the transaction was actually fraudulent.