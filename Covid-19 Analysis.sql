--- Table Covid Deaths ---
select 
  * 
from 
  PortfolioProject..covid_deaths 
order by 
  3, 
  4;

--- Table Covid vaccinations ---
select 
  * 
from 
  PortfolioProject..covid_vaccinations 
order by 
  3, 
  4;

--- 1. Percent of population infected ---
select 
  location, 
  date,
  population,
  total_cases, 
  (total_cases / population)* 100 as [Percent of Population] 
from 
  PortfolioProject..covid_deaths 
where 
  location like '%india%' 
order by 
  date;

--- 2. Countries with highest infection rate compared to population ---
select 
  location, 
  max(population) as [Total Population], 
  max(total_cases) as [Infection count], 
  max(
    (total_cases / population)* 100
  ) as [Percent of Population] 
from 
  PortfolioProject..covid_deaths 
group by 
  location 
order by 
  [Percent of Population] desc;

--- 3. World fatality ratio ---
select 
  location, 
  date, 
  total_cases, 
  total_deaths, 
  (total_deaths / total_cases)* 100 as [Fatality ratio] 
from 
  PortfolioProject..covid_deaths 
order by 
  location, 
  date;

--- 4. fatality ratio of India ---
select 
  location, 
  date, 
  total_cases, 
  total_deaths, 
  (total_deaths / total_cases)* 100 as [Fatality ratio] 
from 
  PortfolioProject..covid_deaths 
where 
  location like '%india%' 
order by 
  date;

--- 5. Death count around the world by countries ---
select 
  location, 
  max(
    cast(total_deaths as int)
  ) as [Total death count] 
from 
  PortfolioProject..covid_deaths 
where 
  continent is not null 
group by 
  location 
order by 
  [Total death count] desc;

--- 5. Death count around the world by continents ---
select 
  continent, 
  max(
    cast(total_deaths as int)
  ) as [Total death count] 
from 
  PortfolioProject..covid_deaths 
where 
  continent is not null 
group by 
  continent 
order by 
  [Total death count] desc;

--- 6. Vaccinations around the world ---
select 
  d.continent, 
  d.location, 
  d.date, 
  d.population, 
  v.new_vaccinations, 
  sum(
    cast(v.new_vaccinations as int)
  ) over (
    partition by d.location 
    order by 
      d.location, 
      d.date
  ) as [Rolling total of vacc.] 
from 
  PortfolioProject..covid_deaths d 
  join PortfolioProject..covid_vaccinations v on d.location = v.location 
  and d.date = v.date 
where 
  d.continent is not null 
order by 
  d.location, 
  d.date;

--- Creating View for Vaccination information ---
create view populationvaccinated as 
select 
  d.continent, 
  d.location, 
  d.date, 
  d.population, 
  v.new_vaccinations, 
  sum(
    cast(v.new_vaccinations as int)
  ) over (
    partition by d.location 
    order by 
      d.location, 
      d.date
  ) as [Rolling total of vacc.] 
from 
  PortfolioProject..covid_deaths d 
  join PortfolioProject..covid_vaccinations v on d.location = v.location 
  and d.date = v.date 
where 
  d.continent is not null;


--- Population vaccinated info (view) ---
select 
  * 
from 
  populationvaccinated;


-- 7. Number of people vaccinated ---

--Using CTE
with popvsvac(
  continent, location, date, population, 
  new_vaccinations, [Rolling total of vacc.]
) as (
  select 
    d.continent, 
    d.location, 
    d.date, 
    d.population, 
    v.new_vaccinations, 
    sum(
      cast(v.new_vaccinations as int)
    ) over (
      partition by d.location 
      order by 
        d.location, 
        d.date
    ) as [Rolling total of vacc.] 
  from 
    PortfolioProject..covid_deaths d 
    join PortfolioProject..covid_vaccinations v on d.location = v.location 
    and d.date = v.date 
  where 
    d.continent is not null
) 
select 
  *, 
  (
    [Rolling total of vacc.] / population
  )* 100 as [Percent of population Vacc.] 
from 
  popvsvac


---Temp table---
drop 
  table if exists #percentpopulationvaccinated
  create table #percentpopulationvaccinated
  (
    continent nvarchar(255), 
    location nvarchar(255), 
    date datetime, 
    population numeric, 
    new_vaccinations numeric, 
    [Rolling total of vacc.] numeric
  ) insert into #percentpopulationvaccinated
select 
  d.continent, 
  d.location, 
  d.date, 
  d.population, 
  v.new_vaccinations, 
  sum(
    cast(v.new_vaccinations as bigint)
  ) over (
    partition by d.location 
    order by 
      d.location, 
      d.date
  ) as [Rolling total of vacc.] 
from 
  PortfolioProject..covid_deaths d 
  join PortfolioProject..covid_vaccinations v on d.location = v.location 
  and d.date = v.date 
select 
  *, 
  (
    [Rolling total of vacc.] / population
  )* 100 as [Percent of population Vacc.] 
from 
  #percentpopulationvaccinated

