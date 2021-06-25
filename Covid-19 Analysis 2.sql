--- Finding relation between Diabetes Prevalence and Covid-19 deaths ----
select 
  d.location, 
  max(d.total_cases) as [Cases], 
  max(
    cast(d.total_deaths as int)
  ) as [Death Count], 
  max(v.diabetes_prevalence) [Diabetes Prevalence] 
from 
  PortfolioProject..covid_deaths d 
  join PortfolioProject..covid_vaccinations v on d.iso_code = v.iso_code 
where 
  d.continent is not null 
  and d.total_deaths is not null 
  and v.diabetes_prevalence is not null 
group by 
  d.location 
order by 
  [Death Count] desc;


--- Finding relation between Smoking Prevalence and Covid-19 deaths ---
select 
  d.location, 
  max(d.total_cases) as [Cases], 
  max(
    cast(d.total_deaths as int)
  ) as [Death Count], 
  max(
    cast(v.male_smokers as float)
  ) as [Male Smokers], 
  max(
    cast(v.female_smokers as float)
  ) as [Female Smokers] 
from 
  PortfolioProject..covid_deaths d 
  join PortfolioProject..covid_vaccinations v on d.iso_code = v.iso_code 
where 
  d.continent is not null 
  and d.total_deaths is not null 
  and v.male_smokers is not null 
  and v.female_smokers is not null 
group by 
  d.location 
order by 
  3 desc;

