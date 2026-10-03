USE dwh_customer360;
GO


/*========================================================
  3. CREATE DWH CLIENT DIMENSION
========================================================*/

IF OBJECT_ID('dbo.dim_client', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.dwh_dim_client
    (
        client_key      INT IDENTITY(1,1) PRIMARY KEY,

        client_number   NVARCHAR(50) NOT NULL,
        first_name      NVARCHAR(100) NULL,
        last_name       NVARCHAR(100) NULL,
        email           NVARCHAR(255) NULL,
        mobile_number   NVARCHAR(50) NULL,
        date_of_birth   DATE NULL,
        gender          NVARCHAR(50) NULL,
        signup_date     DATE NULL,

        CONSTRAINT UQ_dim_client_client_number
            UNIQUE (client_number)
    );
END;
GO


/*========================================================
  4. LOAD CLIENT DATA FROM STAGING
     
========================================================*/

INSERT INTO dbo.dwh_dim_client
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
SELECT DISTINCT
    NULLIF(LTRIM(RTRIM(s.client_number)), '') AS client_number,

    NULLIF(LTRIM(RTRIM(s.first_name)), '') AS first_name,

    NULLIF(LTRIM(RTRIM(s.last_name)), '') AS last_name,

    NULLIF(LOWER(LTRIM(RTRIM(s.email))), '') AS email,

    NULLIF(LTRIM(RTRIM(s.mobile_number)), '') AS mobile_number,

    TRY_CONVERT(DATE, s.date_of_birth) AS date_of_birth,

    NULLIF(LTRIM(RTRIM(s.gender)), '') AS gender,

    TRY_CONVERT(DATE, s.signup_date) AS signup_date

FROM stg_customer360.[dbo].[stg_customer360_raw] AS s

WHERE NULLIF(LTRIM(RTRIM(s.client_number)), '') IS NOT NULL

  /* Prevent duplicate clients */
  AND NOT EXISTS
  (
      SELECT 1
      FROM dbo.dwh_dim_client AS d
      WHERE d.client_number =
            NULLIF(LTRIM(RTRIM(s.client_number)), '')
  );
GO

/*========================================================
  5. CHECK THE CLIENT DIMENSION
========================================================*/
SELECT *
FROM dbo.dwh_dim_client
ORDER BY client_key;
GO