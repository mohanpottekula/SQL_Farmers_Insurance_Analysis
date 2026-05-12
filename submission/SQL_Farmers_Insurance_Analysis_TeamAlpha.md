---
title: "SQL Assignment: Farmers Insurance Analysis (PMFBY)"
author: "Group: TeamAlpha"
subtitle: "Assignment ID: SQL/02 - Executive Summary"
geometry: margin=2.2cm
---

## Problem and Approach

PMFBY is the central crop insurance scheme. Using NDAP data for
2018 to 2021 we looked at who is covered, what is paid as premium
and how this changes over time. The 1,870 row CSV was loaded into
MySQL and the 29 questions in the starter file were answered.

## Key Insights

Coverage is very concentrated. MP, Maharashtra, UP, Rajasthan and
Tamil Nadu account for about 70 percent of farmers in the data.
Bid (MH), Ujjain (MP) and Latur (MH) lead on cumulative premium.

Enrolment fell from about 1.5 crore in 2018 to 1.07 crore in 2021,
while gross premium grew from Rs. 73 cr to Rs. 131 cr. Fewer
farmers but costlier policies.

The cost has moved towards the government. The farmer's share of
gross premium dropped from 19 percent in 2018 to about 11 percent
in 2021. State and central together now fund close to 90 percent.

Female participation stays around 14 to 16 percent in all four
years. Small and marginal farmers form 78 to 86 percent of the
pool, the audience the scheme is meant to reach.

## Assumptions

- Premium columns are in lakhs and InsuredLandArea in thousand
  hectares (`column_description.csv`). Thresholds (500K, 20 cr, 100
  cr) were converted to raw units in the queries.
- The `Year` column is loaded as `Year_` since Year is reserved in
  MySQL. `srcYear` and `Year_` are kept in sync.
- Source is one table, so joins use derived subqueries.
- Census population repeats per district, so state population uses
  max per district then summed.
