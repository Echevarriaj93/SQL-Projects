
select * from PortfolioProject.coviddeaths
where continent is not null; -- null continents are shwoing up as country


-- Top 10 infected countries

select location, max(convert(total_deaths, unsigned int ))
from PortfolioProject.coviddeaths
where continent is not null
group by location
order by max(convert(total_deaths, unsigned int )) desc
limit 10 offset 5; -- EU is showing up as number 1. Not a country.


-- Percentage change over time of deaths in the US

select date, location, total_cases, total_deaths, (total_deaths/total_cases)* 100 as death_percentage_change
from PortfolioProject.coviddeaths
where location like '%united states';

-- Percentage of total cases resulting in death

select location, max(convert(total_cases, unsigned int)) as MaxCases, max(convert(total_deaths, unsigned int)) as MaxDeaths, (max(convert(total_deaths, unsigned int))/max(convert(total_cases, unsigned int)))* 100  as death_percentage
from PortfolioProject.coviddeaths
where location like '%united states'
group by location;

-- Break it down by continent

select continent,  max(convert(total_cases, unsigned int)) as MaxCases,
max(convert(total_deaths, unsigned int)) as MaxDeaths,
(max(convert(total_deaths, unsigned int))/max(convert(total_cases, unsigned int)))* 100  as death_percentage
from PortfolioProject.coviddeaths
where continent is not null
group by continent
order by MaxCases desc
limit 6 offset 1;  -- North America seems to only be factoring in US deaths.

-- Let's try with location instead

select location, max(convert(total_deaths, unsigned int)) as MaxDeaths
from PortfolioProject.coviddeaths
group by location
order by MaxDeaths desc
limit 10 offset 5; 

-- Total Global 
select sum(convert(new_cases, unsigned int)) as Total_Global_Cases, 
sum(convert(new_deaths,unsigned int )) as Total_Global_Deaths,
(sum(convert(new_deaths,unsigned int ))/sum(convert(new_cases, unsigned int)))* 100 as global_death_percent
from PortfolioProject.coviddeaths
where continent is not null ;

-- Join Deaths w. Vaccinations
select *
from PortfolioProject.coviddeaths d
join PortfolioProject.covidvaccinations v
on 
d.location = v.location
and
d.date = v.date;

-- Total population vs vaccinations
select d.location,
sum(convert(v.new_vaccinations, unsigned int)),
sum(convert(d.new_deaths, unsigned int))
from PortfolioProject.coviddeaths d
join PortfolioProject.covidvaccinations v
on 
d.location = v.location
and
d.date = v.date
where d.continent is not null
group by location
order by sum(convert(v.new_vaccinations, unsigned int)) desc; -- China has rolled out the most vaccinations out of any place recorded

