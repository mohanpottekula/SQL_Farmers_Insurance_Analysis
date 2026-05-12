
-- You can only load data from local storage if the local_infile parameter is set to 1
SET GLOBAL local_infile=1;
-- You might need to change the local_infile parameter by editing it in the configuration file
-- Open "my.ini" (Windows) or "my.cnf" (Mac/Linux) and set local_infile=1

-- Another way to load a table is to create the schema first and then use the table data import wizard in MySQL Workbench

CREATE SCHEMA IF NOT EXISTS ndap;

USE ndap;

-- CREATE TABLE IF NOT EXISTS FarmersInsuranceData (
--     rowID INT PRIMARY KEY,
--     srcYear INT,
--     srcStateName VARCHAR(255),
--     srcDistrictName VARCHAR(255),farmersinsurancedata
--     InsuranceUnits INT,
--     TotalFarmersCovered INT,
--     ApplicationsLoaneeFarmers INT,
--     ApplicationsNonLoaneeFarmers INT,
--     InsuredLandArea FLOAT,
--     FarmersPremiumAmount FLOAT,
--     StatePremiumAmount FLOAT,
--     GOVPremiumAmount FLOAT,
--     GrossPremiumAmountToBePaid FLOAT,
--     SumInsured FLOAT,
--     PercentageMaleFarmersCovered FLOAT,
--     PercentageFemaleFarmersCovered FLOAT,
--     PercentageOthersCovered FLOAT,
--     PercentageSCFarmersCovered FLOAT,
--     PercentageSTFarmersCovered FLOAT,
--     PercentageOBCFarmersCovered FLOAT,
--     PercentageGeneralFarmersCovered FLOAT,
--     PercentageMarginalFarmers FLOAT,
--     PercentageSmallFarmers FLOAT,
--     PercentageOtherFarmers FLOAT,
--     YearCode INT,
--     Year_ VARCHAR(255),
--     Country VARCHAR(255),
--     StateCode INT,
--     DistrictCode INT,
--     TotalPopulation INT,
--     TotalPopulationUrban INT,
--     TotalPopulationRural INT,
--     TotalPopulationMale INT,
--     TotalPopulationMaleUrban INT,
--     TotalPopulationMaleRural INT,
--     TotalPopulationFemale INT,
--     TotalPopulationFemaleUrban INT,
--     TotalPopulationFemaleRural INT,
--     NumberOfHouseholds INT,
--     NumberOfHouseholdsUrban INT,
--     NumberOfHouseholdsRural INT,
--     LandAreaUrban FLOAT,
--     LandAreaRural FLOAT,
--     LandArea FLOAT
-- );

-- LOAD DATA LOCAL INFILE "path\data.csv"
-- INTO TABLE FarmersInsuranceData
-- FIELDS TERMINATED BY ','  
-- ENCLOSED BY '"'          
-- LINES TERMINATED BY '\n' 
-- IGNORE 1 ROWS;
