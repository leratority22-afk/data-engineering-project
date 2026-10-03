USE [stg_customer360]
GO

IF NOT EXISTS
(
    
    SELECT 1
    FROM sys.tables
    WHERE name = 'stg_customer360_raw'
      AND schema_id = SCHEMA_ID('dbo')
)
BEGIN

CREATE TABLE [dbo].[stg_customer360_raw](
	[client_number] [nvarchar](50) NOT NULL,
	[first_name] [nvarchar](50) NOT NULL,
	[last_name] [nvarchar](50) NOT NULL,
	[email] [nvarchar](50) NULL,
	[mobile_number] [nvarchar](50) NULL,
	[date_of_birth] [datetime2](7) NOT NULL,
	[gender] [nvarchar](50) NULL,
	[province] [nvarchar](50) NOT NULL,
	[city] [nvarchar](50) NOT NULL,
	[signup_date] [datetime2](7) NOT NULL,
	[event_type] [nvarchar](50) NOT NULL,
	[event_date] [datetime2](7) NOT NULL,
	[account_number] [nvarchar](50) NULL,
	[product_type] [nvarchar](50) NULL,
	[account_status] [nvarchar](50) NULL,
	[credit_limit] [nvarchar](50) NULL,
	[loan_amount] [int] NULL,
	[account_balance] [nvarchar](50) NULL,
	[channel] [nvarchar](50) NULL,
	[interaction_type] [nvarchar](50) NULL,
	[resolved_flag] [nvarchar](50) NULL,
	[transaction_type] [nvarchar](50) NULL,
	[amount] [nvarchar](50) NULL
) ON [PRIMARY]
END
GO


