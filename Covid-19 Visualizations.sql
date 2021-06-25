--- 1. Latest numbers till May 2021 ---
select 
  sum(new_cases) as [Total Cases], 
  sum(
    cast(new_deaths as int)
  ) as [Total Deaths], 
  (
    sum(
      cast(new_deaths as int)
    )/ sum(new_cases)
  )* 100 as [Death Percentage] 
from 
  PortfolioProject..covid_deaths;


--- 2. Total Deaths due to covid by Continents ---
select 
  location, 
  sum(
    cast(new_deaths as int)
  ) as [Total Death Count] 
from 
  PortfolioProject..covid_deaths 
where 
  continent is null 
  and location not in (
    'World', 'European Union', 'International'
  ) 
group by 
  location 
order by 
  [Total Death Count] desc;


--- 3. Countries with highest infection rate ---
select 
  location, 
  population, 
  max(total_cases) as [Population Infected], 
  max(total_cases / population)* 100 as [Percent of Population] 
from 
  PortfolioProject..covid_deaths 
group by 
  location, 
  population 
order by 
  [Percent of Population] desc;


--- 4. Covid-19 cases trend---
select 
  location, 
  population, 
  date, 
  max(total_cases) as [Population Infected], 
  Max(total_cases / population)* 100 as [Percent of Population] 
from 
  PortfolioProject..covid_deaths 
where 
  continent is not null 
group by 
  location, 
  date, 
  population 
order by 
  [Percent of Population] desc;