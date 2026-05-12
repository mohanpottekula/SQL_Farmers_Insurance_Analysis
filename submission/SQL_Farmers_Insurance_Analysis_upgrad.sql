-- SQL Assignment: Farmers Insurance Analysis (PMFBY)
-- Assignment ID: SQL/02
-- Group: upgrad

-- Note: the CSV column "Year" was loaded as Year_ in the table because Year is a
-- reserved word in MySQL. Premium columns are in lakhs and InsuredLandArea is in
-- thousand hectares (as per column_description.csv), so thresholds like 20 cr or
-- 100 cr are translated accordingly inside the queries below.

use ndap;


-- ----------------------------------------------------------------------------------------------
-- SECTION 1. 
-- SELECT Queries [5 Marks]

-- 	Q1.	Retrieve the names of all states (srcStateName) from the dataset.
-- ###
-- 	[2 Marks]
-- ###
-- TYPE YOUR CODE BELOW >
-- <write your answers in the empty spaces given, the length of solution queries (and the solution writing space) can vary>

select distinct srcStateName
from FarmersInsuranceData
order by srcStateName;
###

-- 	Q2.	Retrieve the total number of farmers covered (TotalFarmersCovered) 
-- 		and the sum insured (SumInsured) for each state (srcStateName), ordered by TotalFarmersCovered in descending order.
-- ###
-- 	[3 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

select srcStateName,
       sum(TotalFarmersCovered) as TotalFarmersCovered,
       sum(SumInsured) as SumInsured
from FarmersInsuranceData
group by srcStateName
order by TotalFarmersCovered desc;
-- ###

-- --------------------------------------------------------------------------------------
-- SECTION 2. 
-- Filtering Data (WHERE) [15 Marks]

-- 	Q3.	Retrieve all records where Year is '2020'.
-- ###
-- 	[2 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

select *
from FarmersInsuranceData
where srcYear = 2020;
-- ###

-- 	Q4.	Retrieve all rows where the TotalPopulationRural is greater than 1 million and the srcStateName is 'HIMACHAL PRADESH'.
-- ###
-- 	[3 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

select *
from FarmersInsuranceData
where TotalPopulationRural > 1000000
  and srcStateName = 'HIMACHAL PRADESH';
-- ###

-- 	Q5.	Retrieve the srcStateName, srcDistrictName, and the sum of FarmersPremiumAmount for each district in the year 2018, 
-- 		and display the results ordered by FarmersPremiumAmount in ascending order.
-- ###
-- 	[5 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

select srcStateName, srcDistrictName,
       sum(FarmersPremiumAmount) as FarmersPremiumAmount
from FarmersInsuranceData
where srcYear = 2018
group by srcStateName, srcDistrictName
order by FarmersPremiumAmount asc;
-- ###

-- 	Q6.	Retrieve the total number of farmers covered (TotalFarmersCovered) and the sum of premiums (GrossPremiumAmountToBePaid) for each state (srcStateName) 
-- 		where the insured land area (InsuredLandArea) is greater than 5.0 and the Year is 2018.
-- ###
-- 	[5 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

select srcStateName,
       sum(TotalFarmersCovered) as TotalFarmersCovered,
       sum(GrossPremiumAmountToBePaid) as GrossPremiumAmountToBePaid
from FarmersInsuranceData
where InsuredLandArea > 5.0
  and srcYear = 2018
group by srcStateName
order by TotalFarmersCovered desc;
-- ###
-- ------------------------------------------------------------------------------------------------

-- SECTION 3.
-- Aggregation (GROUP BY) [10 marks]

-- 	Q7. 	Calculate the average insured land area (InsuredLandArea) for each year (srcYear).
-- ###
-- 	[3 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

select srcYear, avg(InsuredLandArea) as AvgInsuredLandArea
from FarmersInsuranceData
group by srcYear
order by srcYear;
-- ###

-- 	Q8. 	Calculate the total number of farmers covered (TotalFarmersCovered) for each district (srcDistrictName) where Insurance units is greater than 0.
-- ###
-- 	[3 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

select srcDistrictName, sum(TotalFarmersCovered) as TotalFarmersCovered
from FarmersInsuranceData
where InsuranceUnits > 0
group by srcDistrictName
order by TotalFarmersCovered desc;
-- ###

-- 	Q9.	For each state (srcStateName), calculate the total premium amounts (FarmersPremiumAmount, StatePremiumAmount, GOVPremiumAmount) 
-- 		and the total number of farmers covered (TotalFarmersCovered). Only include records where the sum insured (SumInsured) is greater than 500,000 (remember to check for scaling).
-- ###
-- 	[4 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

-- SumInsured is in lakhs, so 500000 INR means SumInsured > 5
select srcStateName,
       sum(FarmersPremiumAmount) as FarmersPremiumAmount,
       sum(StatePremiumAmount) as StatePremiumAmount,
       sum(GOVPremiumAmount) as GOVPremiumAmount,
       sum(TotalFarmersCovered) as TotalFarmersCovered
from FarmersInsuranceData
where SumInsured > 5
group by srcStateName
order by TotalFarmersCovered desc;
-- ###

-- -------------------------------------------------------------------------------------------------
-- SECTION 4.
-- Sorting Data (ORDER BY) [10 Marks]

-- 	Q10.	Retrieve the top 5 districts (srcDistrictName) with the highest TotalPopulation in the year 2020.
-- ###
-- 	[2 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

select srcDistrictName, TotalPopulation
from FarmersInsuranceData
where srcYear = 2020
order by TotalPopulation desc
limit 5;
-- ###

-- 	Q11.	Retrieve the srcStateName, srcDistrictName, and SumInsured for the 10 districts with the lowest non-zero FarmersPremiumAmount, 
-- 		ordered by insured sum and then the FarmersPremiumAmount.
-- ###
-- 	[3 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

select srcStateName, srcDistrictName, SumInsured, FarmersPremiumAmount
from FarmersInsuranceData
where FarmersPremiumAmount > 0
order by SumInsured asc, FarmersPremiumAmount asc
limit 10;
###

-- 	Q12. 	Retrieve the top 3 states (srcStateName) along with the year (srcYear) where the ratio of insured farmers (TotalFarmersCovered) to the total population (TotalPopulation) is highest. 
-- 		Sort the results by the ratio in descending order.
-- ###
-- 	[5 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

select srcStateName, srcYear, ratio
from (
    select srcStateName, srcYear,
           sum(TotalFarmersCovered) / nullif(sum(TotalPopulation), 0) as ratio,
           row_number() over (
               partition by srcYear
               order by sum(TotalFarmersCovered) / nullif(sum(TotalPopulation), 0) desc
           ) as rn
    from FarmersInsuranceData
    where TotalPopulation > 0
    group by srcStateName, srcYear
) t
where rn <= 3
order by srcYear, ratio desc;
-- ###

-- -------------------------------------------------------------------------------------------------

-- SECTION 5.
-- String Functions [6 Marks]

-- 	Q13. 	Create StateShortName by retrieving the first 3 characters of the srcStateName for each unique state.
-- ###
-- 	[2 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

select distinct srcStateName, left(srcStateName, 3) as StateShortName
from FarmersInsuranceData
order by srcStateName;
-- ###

-- 	Q14. 	Retrieve the srcDistrictName where the district name starts with 'B'.
-- ###
-- 	[2 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

select distinct srcDistrictName
from FarmersInsuranceData
where srcDistrictName like 'B%'
order by srcDistrictName;
-- ###

-- 	Q15. 	Retrieve the srcStateName and srcDistrictName where the district name contains the word 'pur' at the end.
-- ###
-- 	[2 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

select distinct srcStateName, srcDistrictName
from FarmersInsuranceData
where srcDistrictName like '%pur'
order by srcStateName, srcDistrictName;
-- ###

-- -------------------------------------------------------------------------------------------------

-- SECTION 6.
-- Joins [14 Marks]

-- 	Q16. 	Perform an INNER JOIN between the srcStateName and srcDistrictName columns to retrieve the aggregated FarmersPremiumAmount for districts where the district’s Insurance units for an individual year are greater than 10.
-- ###
-- 	[4 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

-- The data is in one denormalised table, so I built two subqueries
-- (one of states, one of district-year rows with InsuranceUnits > 10)
-- and inner joined them on state name.
select s.srcStateName, d.srcDistrictName,
       sum(d.FarmersPremiumAmount) as FarmersPremiumAmount
from (select distinct srcStateName from FarmersInsuranceData) s
inner join (
    select srcStateName, srcDistrictName, FarmersPremiumAmount
    from FarmersInsuranceData
    where InsuranceUnits > 10
) d on s.srcStateName = d.srcStateName
group by s.srcStateName, d.srcDistrictName
order by FarmersPremiumAmount desc;
-- ###

-- 	Q17.	Write a query that retrieves srcStateName, srcDistrictName, Year, TotalPopulation for each district and the the highest recorded FarmersPremiumAmount for that district over all available years
-- 		Return only those districts where the highest FarmersPremiumAmount exceeds 20 crores.
-- ###
-- 	[5 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

-- 20 crore = 2000 lakhs in the raw column
select f.srcStateName, f.srcDistrictName, f.Year_ as Year,
       f.TotalPopulation,
       f.FarmersPremiumAmount as HighestFarmersPremiumAmount
from FarmersInsuranceData f
inner join (
    select srcStateName, srcDistrictName,
           max(FarmersPremiumAmount) as MaxPrem
    from FarmersInsuranceData
    group by srcStateName, srcDistrictName
    having max(FarmersPremiumAmount) > 2000
) m
  on f.srcStateName = m.srcStateName
 and f.srcDistrictName = m.srcDistrictName
 and f.FarmersPremiumAmount = m.MaxPrem
order by f.FarmersPremiumAmount desc;
-- ###

-- 	Q18.	Perform a LEFT JOIN to combine the total population statistics with the farmers’ data (TotalFarmersCovered, SumInsured) for each district and state. 
-- 		Return the total premium amount (FarmersPremiumAmount) and the average population count for each district aggregated over the years, where the total FarmersPremiumAmount is greater than 100 crores.
-- 		Sort the results by total farmers' premium amount, highest first.
-- ###
-- 	[5 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

-- 100 crore = 10000 lakhs
select fa.srcStateName, fa.srcDistrictName,
       fa.TotalFarmersCovered, fa.SumInsured,
       fa.TotalFarmersPremiumAmount, pop.AvgPopulation
from (
    select srcStateName, srcDistrictName,
           sum(TotalFarmersCovered) as TotalFarmersCovered,
           sum(SumInsured) as SumInsured,
           sum(FarmersPremiumAmount) as TotalFarmersPremiumAmount
    from FarmersInsuranceData
    group by srcStateName, srcDistrictName
) fa
left join (
    select srcStateName, srcDistrictName,
           avg(TotalPopulation) as AvgPopulation
    from FarmersInsuranceData
    group by srcStateName, srcDistrictName
) pop on fa.srcStateName = pop.srcStateName
     and fa.srcDistrictName = pop.srcDistrictName
where fa.TotalFarmersPremiumAmount > 10000
order by fa.TotalFarmersPremiumAmount desc;
-- ###

-- -------------------------------------------------------------------------------------------------

-- SECTION 7.
-- Subqueries [10 Marks]

-- 	Q19.	Write a query to find the districts (srcDistrictName) where the TotalFarmersCovered is greater than the average TotalFarmersCovered across all records.
-- ###
-- 	[2 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

select srcStateName, srcDistrictName, srcYear, TotalFarmersCovered
from FarmersInsuranceData
where TotalFarmersCovered > (select avg(TotalFarmersCovered) from FarmersInsuranceData)
order by TotalFarmersCovered desc;
-- ###

-- 	Q20.	Write a query to find the srcStateName where the SumInsured is higher than the SumInsured of the district with the highest FarmersPremiumAmount.
-- ###
-- 	[3 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

-- The "district with highest farmers' premium amount" is taken as the district
-- with the highest aggregated FarmersPremiumAmount over all years.
select srcStateName, sum(SumInsured) as StateSumInsured
from FarmersInsuranceData
group by srcStateName
having sum(SumInsured) > (
    select DistSumInsured from (
        select srcStateName, srcDistrictName,
               sum(FarmersPremiumAmount) as DistPrem,
               sum(SumInsured) as DistSumInsured
        from FarmersInsuranceData
        group by srcStateName, srcDistrictName
        order by DistPrem desc
        limit 1
    ) top_d
)
order by StateSumInsured desc;
-- ###

-- 	Q21.	Write a query to find the srcDistrictName where the FarmersPremiumAmount is higher than the average FarmersPremiumAmount of the state that has the highest TotalPopulation.
-- ###
-- 	[5 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

-- Census population repeats every year per district, so the state with the highest
-- population is found by max(TotalPopulation) per district then sum per state.
select srcStateName, srcDistrictName, srcYear, FarmersPremiumAmount
from FarmersInsuranceData
where FarmersPremiumAmount > (
    select avg(FarmersPremiumAmount)
    from FarmersInsuranceData
    where srcStateName = (
        select srcStateName from (
            select srcStateName, sum(DistPop) as StatePop
            from (
                select srcStateName, srcDistrictName,
                       max(TotalPopulation) as DistPop
                from FarmersInsuranceData
                group by srcStateName, srcDistrictName
            ) dp
            group by srcStateName
            order by StatePop desc
            limit 1
        ) top_state
    )
)
order by FarmersPremiumAmount desc;
-- ###

-- -------------------------------------------------------------------------------------------------

-- SECTION 8.
-- Advanced SQL Functions (Window Functions) [10 Marks]

-- 	Q22.	Use the ROW_NUMBER() function to assign a row number to each record in the dataset ordered by total farmers covered in descending order.
-- ###
-- 	[3 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

select rowID, srcStateName, srcDistrictName, srcYear, TotalFarmersCovered,
       row_number() over (order by TotalFarmersCovered desc) as RowNum
from FarmersInsuranceData;
-- ###

-- 	Q23.	Use the RANK() function to rank the districts (srcDistrictName) based on the SumInsured (descending) and partition by alphabetical srcStateName.
-- ###
-- 	[3 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

select srcStateName, srcDistrictName, srcYear, SumInsured,
       rank() over (partition by srcStateName order by SumInsured desc) as DistrictRank
from FarmersInsuranceData
order by srcStateName, DistrictRank;
-- ###

-- 	Q24.	Use the SUM() window function to calculate a cumulative sum of FarmersPremiumAmount for each district (srcDistrictName), ordered ascending by the srcYear, partitioned by srcStateName.
-- ###
-- 	[4 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

select srcStateName, srcDistrictName, srcYear, FarmersPremiumAmount,
       sum(FarmersPremiumAmount) over (
           partition by srcStateName, srcDistrictName
           order by srcYear asc
       ) as CumulativeFarmersPremiumAmount
from FarmersInsuranceData
order by srcStateName, srcDistrictName, srcYear;
-- ###

-- -------------------------------------------------------------------------------------------------

-- SECTION 9.
-- Data Integrity (Constraints, Foreign Keys) [4 Marks]

-- 	Q25.	Create a table 'districts' with DistrictCode as the primary key and columns for DistrictName and StateCode. 
-- 		Create another table 'states' with StateCode as primary key and column for StateName.
-- ###
-- 	[2 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

drop table if exists districts;
drop table if exists states;

create table states (
    StateCode int not null,
    StateName varchar(255) not null,
    primary key (StateCode)
);

create table districts (
    DistrictCode int not null,
    DistrictName varchar(255) not null,
    StateCode int,
    primary key (DistrictCode)
);
-- ###

-- 	Q26.	Add a foreign key constraint to the districts table that references the StateCode column from a states table.
-- ###
-- 	[2 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

alter table districts
add constraint fk_districts_state
foreign key (StateCode) references states (StateCode)
on update cascade
on delete restrict;
-- ###

-- -------------------------------------------------------------------------------------------------

-- SECTION 10.
-- UPDATE and DELETE [6 Marks]

-- 	Q27.	Update the FarmersPremiumAmount to 500.0 for the record where rowID is 1.
-- ###
-- 	[2 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

update FarmersInsuranceData
set FarmersPremiumAmount = 500.0
where rowID = 1;
-- ###

-- 	Q28.	Update the Year to '2021' for all records where srcStateName is 'HIMACHAL PRADESH'.
-- ###
-- 	[2 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

-- updating srcYear (the numeric year column) and Year_ together to stay consistent
update FarmersInsuranceData
set srcYear = 2021,
    Year_ = 'Calendar Year (Jan - Dec), 2021'
where srcStateName = 'HIMACHAL PRADESH';
-- ###

-- 	Q29.	Delete all records where the TotalFarmersCovered is less than 10000 and Year is 2020.
-- ###
-- 	[2 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

delete from FarmersInsuranceData
where TotalFarmersCovered < 10000
  and srcYear = 2020;
-- ###