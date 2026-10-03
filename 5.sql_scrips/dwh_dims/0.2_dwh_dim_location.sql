
/*========================================================
  3. CREATE LOCATION DIMENSION
========================================================*/

IF OBJECT_ID('dbo.dwh_dim_location', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.dwh_dim_location
    (
        location_key INT IDENTITY(1,1) PRIMARY KEY,

        province     NVARCHAR(100) NULL,
        city         NVARCHAR(100) NULL,

        CONSTRAINT UQ_dim_location
            UNIQUE (province, city)
    );
END;
GO


INSERT INTO dbo.dwh_dim_location
(
    province,
    city
)
SELECT DISTINCT
    NULLIF(LTRIM(RTRIM(s.province)), '') AS province,

    NULLIF(LTRIM(RTRIM(s.city)), '') AS city

FROM stg_customer360.[dbo].[stg_customer360_raw]AS s

WHERE
    /* Do not load completely empty locations */
    (
        NULLIF(LTRIM(RTRIM(s.province)), '') IS NOT NULL
        OR
        NULLIF(LTRIM(RTRIM(s.city)), '') IS NOT NULL
    )

    /* Prevent duplicate locations */
    AND NOT EXISTS
    (
        SELECT 1
        FROM dbo.dwh_dim_location AS d
        WHERE
            ISNULL(d.province, '') =
            ISNULL(NULLIF(LTRIM(RTRIM(s.province)), ''), '')

            AND

            ISNULL(d.city, '') =
            ISNULL(NULLIF(LTRIM(RTRIM(s.city)), ''), '')
    );
GO

