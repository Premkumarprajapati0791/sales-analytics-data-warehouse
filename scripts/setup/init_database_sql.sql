-- Script Purpose: 
--    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
--    within the database: 'bronze', 'silver', and 'gold'.--


-- create data bases

CREATE DATABASE bronze;

CREATE DATABASE silver;

CREATE DATABASE gold;