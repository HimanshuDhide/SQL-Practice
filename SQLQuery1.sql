select * from CovidDeaths order by 3,4;

-- Select data that will be used

select location, date, total_cases, new_cases, total_deaths, population
from Portfolio_project .. CovidDeaths order by 1,2

select location, date, total_cases, new_cases, total_deaths, population,
(total_deaths/total_cases)*100 as death_percentage
from Portfolio_project .. CovidDeaths 