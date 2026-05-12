"""Build the submission SQL file by injecting answers into the unmodified starter."""

import re
import pathlib

ROOT = pathlib.Path("/Users/dhanesh/Desktop/p/mohan-db-assignment")
STARTER = ROOT / "SQL_Assg_PMFBY_Dataset_Starter" / "SQL_Assg_Farmers_Insurance_Questions_Starter.sql"
OUT = ROOT / "submission" / "SQL_Farmers_Insurance_Analysis_upgrad.sql"

HEADER = """\
-- SQL Assignment: Farmers Insurance Analysis (PMFBY)
-- Assignment ID: SQL/02
-- Group: upgrad

-- Note: the CSV column "Year" was loaded as Year_ in the table because Year is a
-- reserved word in MySQL. Premium columns are in lakhs and InsuredLandArea is in
-- thousand hectares (as per column_description.csv), so thresholds like 20 cr or
-- 100 cr are translated accordingly inside the queries below.

"""

ANSWERS = {
    1: """select distinct srcStateName
from FarmersInsuranceData
order by srcStateName;
""",
    2: """select srcStateName,
       sum(TotalFarmersCovered) as TotalFarmersCovered,
       sum(SumInsured) as SumInsured
from FarmersInsuranceData
group by srcStateName
order by TotalFarmersCovered desc;
""",
    3: """select *
from FarmersInsuranceData
where srcYear = 2020;
""",
    4: """select *
from FarmersInsuranceData
where TotalPopulationRural > 1000000
  and srcStateName = 'HIMACHAL PRADESH';
""",
    5: """select srcStateName, srcDistrictName,
       sum(FarmersPremiumAmount) as FarmersPremiumAmount
from FarmersInsuranceData
where srcYear = 2018
group by srcStateName, srcDistrictName
order by FarmersPremiumAmount asc;
""",
    6: """select srcStateName,
       sum(TotalFarmersCovered) as TotalFarmersCovered,
       sum(GrossPremiumAmountToBePaid) as GrossPremiumAmountToBePaid
from FarmersInsuranceData
where InsuredLandArea > 5.0
  and srcYear = 2018
group by srcStateName
order by TotalFarmersCovered desc;
""",
    7: """select srcYear, avg(InsuredLandArea) as AvgInsuredLandArea
from FarmersInsuranceData
group by srcYear
order by srcYear;
""",
    8: """select srcDistrictName, sum(TotalFarmersCovered) as TotalFarmersCovered
from FarmersInsuranceData
where InsuranceUnits > 0
group by srcDistrictName
order by TotalFarmersCovered desc;
""",
    9: """-- SumInsured is in lakhs, so 500000 INR means SumInsured > 5
select srcStateName,
       sum(FarmersPremiumAmount) as FarmersPremiumAmount,
       sum(StatePremiumAmount) as StatePremiumAmount,
       sum(GOVPremiumAmount) as GOVPremiumAmount,
       sum(TotalFarmersCovered) as TotalFarmersCovered
from FarmersInsuranceData
where SumInsured > 5
group by srcStateName
order by TotalFarmersCovered desc;
""",
    10: """select srcDistrictName, TotalPopulation
from FarmersInsuranceData
where srcYear = 2020
order by TotalPopulation desc
limit 5;
""",
    11: """select srcStateName, srcDistrictName, SumInsured, FarmersPremiumAmount
from FarmersInsuranceData
where FarmersPremiumAmount > 0
order by SumInsured asc, FarmersPremiumAmount asc
limit 10;
""",
    12: """select srcStateName, srcYear, ratio
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
""",
    13: """select distinct srcStateName, left(srcStateName, 3) as StateShortName
from FarmersInsuranceData
order by srcStateName;
""",
    14: """select distinct srcDistrictName
from FarmersInsuranceData
where srcDistrictName like 'B%'
order by srcDistrictName;
""",
    15: """select distinct srcStateName, srcDistrictName
from FarmersInsuranceData
where srcDistrictName like '%pur'
order by srcStateName, srcDistrictName;
""",
    16: """-- The data is in one denormalised table, so I built two subqueries
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
""",
    17: """-- 20 crore = 2000 lakhs in the raw column
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
""",
    18: """-- 100 crore = 10000 lakhs
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
""",
    19: """select srcStateName, srcDistrictName, srcYear, TotalFarmersCovered
from FarmersInsuranceData
where TotalFarmersCovered > (select avg(TotalFarmersCovered) from FarmersInsuranceData)
order by TotalFarmersCovered desc;
""",
    20: """-- The "district with highest farmers' premium amount" is taken as the district
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
""",
    21: """-- Census population repeats every year per district, so the state with the highest
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
""",
    22: """select rowID, srcStateName, srcDistrictName, srcYear, TotalFarmersCovered,
       row_number() over (order by TotalFarmersCovered desc) as RowNum
from FarmersInsuranceData;
""",
    23: """select srcStateName, srcDistrictName, srcYear, SumInsured,
       rank() over (partition by srcStateName order by SumInsured desc) as DistrictRank
from FarmersInsuranceData
order by srcStateName, DistrictRank;
""",
    24: """select srcStateName, srcDistrictName, srcYear, FarmersPremiumAmount,
       sum(FarmersPremiumAmount) over (
           partition by srcStateName, srcDistrictName
           order by srcYear asc
       ) as CumulativeFarmersPremiumAmount
from FarmersInsuranceData
order by srcStateName, srcDistrictName, srcYear;
""",
    25: """drop table if exists districts;
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
""",
    26: """alter table districts
add constraint fk_districts_state
foreign key (StateCode) references states (StateCode)
on update cascade
on delete restrict;
""",
    27: """update FarmersInsuranceData
set FarmersPremiumAmount = 500.0
where rowID = 1;
""",
    28: """-- updating srcYear (the numeric year column) and Year_ together to stay consistent
update FarmersInsuranceData
set srcYear = 2021,
    Year_ = 'Calendar Year (Jan - Dec), 2021'
where srcStateName = 'HIMACHAL PRADESH';
""",
    29: """delete from FarmersInsuranceData
where TotalFarmersCovered < 10000
  and srcYear = 2020;
""",
}

# Read starter verbatim
starter_text = STARTER.read_text(encoding="utf-8")
lines = starter_text.splitlines(keepends=True)

out_lines = [HEADER]
current_q = None

i = 0
while i < len(lines):
    line = lines[i]
    out_lines.append(line)

    m = re.match(r"^-- \tQ(\d+)\.", line)
    if m:
        current_q = int(m.group(1))

    if line.rstrip() == "-- TYPE YOUR CODE BELOW >":
        j = i + 1
        while j < len(lines) and lines[j].lstrip().startswith("-- <"):
            out_lines.append(lines[j])
            j += 1
        if current_q is not None and current_q in ANSWERS:
            out_lines.append("\n")
            out_lines.append(ANSWERS[current_q])
        k = j
        while k < len(lines) and lines[k].lstrip().rstrip() not in ("###", "-- ###"):
            k += 1
        i = k - 1

    i += 1

OUT.write_text("".join(out_lines), encoding="utf-8")
print(f"Wrote {OUT} ({OUT.stat().st_size} bytes)")
