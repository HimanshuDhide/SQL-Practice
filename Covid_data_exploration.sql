select * from Portfolio_project..CovidDeaths where continent is not null
use Portfolio_project
select location, total_cases, new_cases, total_deaths, population
from Portfolio_project..CovidDeaths where continent is not null

SELECT location, total_cases, total_deaths, (CAST (total_deaths as float)/cast (total_cases as float))*100 as death_percentage
,date from Portfolio_project..CovidDeaths where location= 'India'

select max(CAST(total_deaths as float)/CAST(total_cases as float)*100) 
from CovidDeaths where location='India'

Select location, date, total_cases,population, (cast (total_cases as float)/ population)*100 as percentage_of_infected
from CovidDeaths where location='India'

Select location, max(total_cases) as highest_infected_count, MAX(CAST(total_cases as float)/population)*100 as Highest_rate_of_infection
from CovidDeaths where continent is not null group by location,population order by  Highest_rate_of_infection desc

Select location, max(total_cases) as highest_infected_count, MAX(CAST(total_cases as float)/population)*100 as Highest_rate_of_infection
from CovidDeaths where location='India' group by location

Select location, max(total_deaths) as highest_death_count from CovidDeaths group by location order by 2 desc

Select continent, max(total_deaths) as highest_death_count from CovidDeaths
where continent is not null group by continent order by 2 desc

Select location, max(total_deaths) as highest_death_count from CovidDeaths
where continent is null group by continent,location order by 2 desc

Select continent, max(total_deaths) as highest_death_count from CovidDeaths
where continent is not null group by continent order by 2 desc

--Global numbers
SELECT date, SUM(CAST(new_cases AS FLOAT)) AS total_cases, SUM(CAST(new_deaths AS FLOAT)) AS Total_deaths,
SUM(CAST(new_deaths AS FLOAT)) /SUM(CAST(new_cases AS FLOAT)) * 100 AS Death_percentage
FROM CovidDeaths where continent is not null GROUP BY date ORDER BY 1,2

SELECT SUM(CAST(new_cases AS FLOAT)) AS total_cases, SUM(CAST(new_deaths AS FLOAT)) AS Total_deaths,
SUM(CAST(new_deaths AS FLOAT)) /SUM(CAST(new_cases AS FLOAT)) * 100 AS Death_percentage
FROM CovidDeaths where continent is not null ORDER BY 1,2


--Vacination Dataset
SELECT * FROM CovidVaccinations

SELECT * FROM CovidDeaths  dea
join CovidVaccinations vac on dea.location=vac.location and dea.date =vac.date

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM CovidDeaths dea join CovidVaccinations vac on dea.location=vac.location and
dea.date=vac.date where dea.continent is not null order by 2,3 


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.date)
as totalpeoplevaccinated
FROM CovidDeaths dea join CovidVaccinations vac on dea.location=vac.location and
dea.date=vac.date where dea.continent is not null order by 2,3 

--using CTE making new table
WITH popVSvac (continent, location, date, population, new_vaccination, totalPeoplevaccinated)
AS (
    SELECT 
        dea.continent, 
        dea.location, 
        dea.date, 
        dea.population, 
        vac.new_vaccinations,
        SUM(CONVERT(INT, vac.new_vaccinations)) 
            OVER (PARTITION BY dea.location ORDER BY dea.date) AS totalPeoplevaccinated
    FROM CovidDeaths dea 
    JOIN CovidVaccinations vac 
        ON dea.location = vac.location 
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
)

SELECT *, (Convert(float, totalPeoplevaccinated)/population)*100 as Percentage_of_people_vaccinated
FROM popVSvac

--Temp table

create table #Percentage_of_people_vaccinated(
continent nvarchar(255),Location nvarchar(255), date datetime, population int,
new_vaccinations numeric,totalPeoplevaccinated numeric
)

Insert into #Percentage_of_people_vaccinated
SELECT 
        dea.continent, 
        dea.location, 
        dea.date, 
        dea.population, 
        vac.new_vaccinations,
        SUM(CONVERT(INT, vac.new_vaccinations)) 
            OVER (PARTITION BY dea.location ORDER BY dea.date) AS totalPeoplevaccinated
    FROM CovidDeaths dea 
    JOIN CovidVaccinations vac 
        ON dea.location = vac.location 
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL order by 1,2

SELECT *, (Convert(float, totalPeoplevaccinated)/population)*100 as Percentage_of_people_vaccinated
FROM #Percentage_of_people_vaccinated

--view
CREATE VIEW Percentage_of_people_vaccinated AS
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations,
    SUM(CONVERT(INT, vac.new_vaccinations)) 
        OVER (PARTITION BY dea.location ORDER BY dea.date) AS totalPeoplevaccinated
FROM CovidDeaths dea 
JOIN CovidVaccinations vac 
    ON dea.location = vac.location 
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

SELECT * 
FROM Percentage_of_people_vaccinated 
ORDER BY location, date;
