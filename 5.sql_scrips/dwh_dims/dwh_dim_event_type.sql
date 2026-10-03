/*========================================================
  3. CREATE DIM_EVENT_TYPE
========================================================*/

IF OBJECT_ID('dbo.dwh_dim_event_type', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.dwh_dim_event_type
    (
        event_type_key INT IDENTITY(1,1) PRIMARY KEY,

        event_type NVARCHAR(100) NULL,

        CONSTRAINT UQ_dim_event_type
            UNIQUE (event_type)
    );
END;
GO



/*========================================================
  4. LOAD EVENT TYPE FROM STAGING
     
 
========================================================*/

INSERT INTO dbo.dwh_dim_event_type
(
    event_type
)
SELECT DISTINCT

    NULLIF(
        LTRIM(RTRIM(s.event_type)),
        ''
    ) AS event_type

FROM stg_customer360.dbo.stg_dim_event_type AS s

WHERE
    /* Do not load blank event types */
    NULLIF(
        LTRIM(RTRIM(s.event_type)),
        ''
    ) IS NOT NULL

    /* Prevent duplicate event types */
    AND NOT EXISTS
    (
        SELECT 1
        FROM dbo.dwh_dim_event_type AS d
        WHERE d.event_type =
              NULLIF(
                  LTRIM(RTRIM(s.event_type)),
                  ''
              )
    );
GO