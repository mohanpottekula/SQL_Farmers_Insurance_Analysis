-- Setup script for PMFBY assignment
-- Creates schema, table, loads CSV data with NULL handling

SET GLOBAL local_infile = 1;

DROP SCHEMA IF EXISTS ndap;
CREATE SCHEMA ndap;
USE ndap;

CREATE TABLE FarmersInsuranceData (
    rowID INT PRIMARY KEY,
    srcYear INT,
    srcStateName VARCHAR(255),
    srcDistrictName VARCHAR(255),
    InsuranceUnits INT,
    TotalFarmersCovered INT,
    ApplicationsLoaneeFarmers INT,
    ApplicationsNonLoaneeFarmers INT,
    InsuredLandArea DOUBLE,
    FarmersPremiumAmount DOUBLE,
    StatePremiumAmount DOUBLE,
    GOVPremiumAmount DOUBLE,
    GrossPremiumAmountToBePaid DOUBLE,
    SumInsured DOUBLE,
    PercentageMaleFarmersCovered DOUBLE,
    PercentageFemaleFarmersCovered DOUBLE,
    PercentageOthersCovered DOUBLE,
    PercentageSCFarmersCovered DOUBLE,
    PercentageSTFarmersCovered DOUBLE,
    PercentageOBCFarmersCovered DOUBLE,
    PercentageGeneralFarmersCovered DOUBLE,
    PercentageMarginalFarmers DOUBLE,
    PercentageSmallFarmers DOUBLE,
    PercentageOtherFarmers DOUBLE,
    YearCode INT,
    Year_ VARCHAR(255),
    Country VARCHAR(255),
    StateCode INT,
    DistrictCode INT,
    TotalPopulation BIGINT,
    TotalPopulationUrban BIGINT,
    TotalPopulationRural BIGINT,
    TotalPopulationMale BIGINT,
    TotalPopulationMaleUrban BIGINT,
    TotalPopulationMaleRural BIGINT,
    TotalPopulationFemale BIGINT,
    TotalPopulationFemaleUrban BIGINT,
    TotalPopulationFemaleRural BIGINT,
    NumberOfHouseholds BIGINT,
    NumberOfHouseholdsUrban BIGINT,
    NumberOfHouseholdsRural BIGINT,
    LandAreaUrban DOUBLE,
    LandAreaRural DOUBLE,
    LandArea DOUBLE
);

LOAD DATA LOCAL INFILE '/Users/dhanesh/Desktop/p/mohan-db-assignment/SQL_Assg_PMFBY_Dataset_Starter/Data_PMFBY/data.csv'
INTO TABLE FarmersInsuranceData
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(rowID, srcYear, srcStateName, srcDistrictName, InsuranceUnits, TotalFarmersCovered,
 ApplicationsLoaneeFarmers, ApplicationsNonLoaneeFarmers, InsuredLandArea,
 FarmersPremiumAmount, StatePremiumAmount, GOVPremiumAmount, GrossPremiumAmountToBePaid,
 SumInsured,
 @PercentageMaleFarmersCovered, @PercentageFemaleFarmersCovered, @PercentageOthersCovered,
 @PercentageSCFarmersCovered, @PercentageSTFarmersCovered, @PercentageOBCFarmersCovered,
 @PercentageGeneralFarmersCovered, @PercentageMarginalFarmers, @PercentageSmallFarmers,
 @PercentageOtherFarmers,
 YearCode, Year_, Country, StateCode, DistrictCode,
 TotalPopulation, TotalPopulationUrban, TotalPopulationRural,
 TotalPopulationMale, TotalPopulationMaleUrban, TotalPopulationMaleRural,
 TotalPopulationFemale, TotalPopulationFemaleUrban, TotalPopulationFemaleRural,
 NumberOfHouseholds, NumberOfHouseholdsUrban, NumberOfHouseholdsRural,
 LandAreaUrban, LandAreaRural, LandArea)
SET
  PercentageMaleFarmersCovered    = NULLIF(@PercentageMaleFarmersCovered, ''),
  PercentageFemaleFarmersCovered  = NULLIF(@PercentageFemaleFarmersCovered, ''),
  PercentageOthersCovered         = NULLIF(@PercentageOthersCovered, ''),
  PercentageSCFarmersCovered      = NULLIF(@PercentageSCFarmersCovered, ''),
  PercentageSTFarmersCovered      = NULLIF(@PercentageSTFarmersCovered, ''),
  PercentageOBCFarmersCovered     = NULLIF(@PercentageOBCFarmersCovered, ''),
  PercentageGeneralFarmersCovered = NULLIF(@PercentageGeneralFarmersCovered, ''),
  PercentageMarginalFarmers       = NULLIF(@PercentageMarginalFarmers, ''),
  PercentageSmallFarmers          = NULLIF(@PercentageSmallFarmers, ''),
  PercentageOtherFarmers          = NULLIF(@PercentageOtherFarmers, '');

SELECT COUNT(*) AS row_count FROM FarmersInsuranceData;
