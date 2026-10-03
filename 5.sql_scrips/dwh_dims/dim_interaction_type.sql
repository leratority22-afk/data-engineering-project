/*========================================================
  3. CREATE DIM_INTERACTION_TYPE
========================================================*/

IF OBJECT_ID('dbo.dwh_dim_interaction_type', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.dwh_dim_interaction_type
    (
        interaction_type_key INT IDENTITY(1,1) PRIMARY KEY,

        interaction_type NVARCHAR(100) NULL,

        CONSTRAINT UQ_dim_interaction_type
            UNIQUE (interaction_type)
    );
END;
GO


/*========================================================
  4. LOAD INTERACTION TYPE FROM STAGING
     
========================================================*/

INSERT INTO dbo.dwh_dim_interaction_type
(
    interaction_type
)
SELECT DISTINCT

    NULLIF(
        LTRIM(RTRIM(s.interaction_type)),
        ''
    ) AS interaction_type

FROM stg_customer360.dbo.stg_dim_interaction_type AS s

WHERE
    /* Do not load blank interaction types */
    NULLIF(
        LTRIM(RTRIM(s.interaction_type)),
        ''
    ) IS NOT NULL

    /* Prevent duplicate interaction types */
    AND NOT EXISTS
    (
        SELECT 1
        FROM dbo.dwh_dim_interaction_type AS d
        WHERE d.interaction_type =
              NULLIF(
                  LTRIM(RTRIM(s.interaction_type)),
                  ''
              )
    );
GO

