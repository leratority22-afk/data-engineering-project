IF DB_ID('dwh_customer360') IS NULL
BEGIN
    CREATE DATABASE dwh_customer360;
END;
GO