
USE stg_customer360;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.tables
    WHERE name = 'dim_client'
      AND schema_id = SCHEMA_ID('dbo')
)
BEGIN
    CREATE TABLE dbo.dim_client
    (
        client_number   NVARCHAR(50),
        first_name      NVARCHAR(100),
        last_name       NVARCHAR(100),
        email           NVARCHAR(250),
        mobile_number   NVARCHAR(50),
        date_of_birth   DATE,
        gender          NVARCHAR(20),
        signup_date     DATE
    );
END;
GO


USE stg_customer360;
GO

INSERT INTO dbo.dim_client
(
    client_number,
    first_name,
    last_name,
    email,
    mobile_number,
    date_of_birth,
    gender,
    signup_date
)
SELECT
    s.client_number,
    s.first_name,
    s.last_name,
    s.email,
    s.mobile_number,
    s.date_of_birth,
    s.gender,
    s.signup_date
FROM [stg_customer360].[dbo].[stg_customer360_raw]AS s
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.dim_client AS d
    WHERE d.client_number = s.client_number
);
GO


/* =========================================================
   CUSTOMER360 DATA WAREHOUSE - CLIENT DIMENSION
   Staging table is NOT changed.
   Cleaning happens during the DWH load.
   ========================================================= */

USE ;
GO

/* =========================================================
   1. CREATE DIM_CLIENT TABLE
   ========================================================= */

IF OBJECT_ID('dbo.dwh_dim_client', 'U') IS NULL
BEGIN

    CREATE TABLE dbo.dwh_dim_client
    (
        client_key      INT IDENTITY(1,1) PRIMARY KEY,

        client_number   NVARCHAR(50)  NOT NULL,
        first_name      NVARCHAR(100) NULL,
        last_name       NVARCHAR(100) NULL,
        email           NVARCHAR(150) NULL,
        mobile_number   NVARCHAR(50)  NULL,
        date_of_birth   DATE          NULL,
        gender          NVARCHAR(50)  NULL,
        signup_date     DATE          NULL
    );

END;
GO


/* =========================================================
   2. LOAD CLIENT DATA FROM STAGING
   ========================================================= */

INSERT INTO dbo.dim_client
(
    client_number,
    first_name,
    last_name,
    email,
    mobile_number,
    date_of_birth,
    gender,
    signup_date
)
SELECT
    LTRIM(RTRIM(s.client_number)),

    NULLIF(LTRIM(RTRIM(s.first_name)), ''),

    NULLIF(LTRIM(RTRIM(s.last_name)), ''),

    NULLIF(LOWER(LTRIM(RTRIM(s.email))), ''),

    NULLIF(LTRIM(RTRIM(s.mobile_number)), ''),

    TRY_CONVERT(DATE, s.date_of_birth),

    NULLIF(LTRIM(RTRIM(s.gender)), ''),

    TRY_CONVERT(DATE, s.signup_date)

FROM stg_customer360_data.dbo.stg_customer360 AS s

WHERE NULLIF(LTRIM(RTRIM(s.client_number)), '') IS NOT NULL

AND NOT EXISTS
(
    SELECT 1
    FROM dbo.dim_client AS d
    WHERE d.client_number =
          LTRIM(RTRIM(s.client_number))
);
GO


/* =========================================================
   3. CHECK THE LOADED CLIENT DATA
   ========================================================= */

SELECT
    client_key,
    client_number,
    first_name,
    last_name,
    email,
    mobile_number,
    date_of_birth,
    gender,
    signup_date
FROM dbo.dim_client
ORDER BY client_key;
GO


/* =========================================================
   4. CHECK NUMBER OF CLIENTS
   ========================================================= */

SELECT COUNT(*) AS total_clients
FROM dbo.dim_client;
GO