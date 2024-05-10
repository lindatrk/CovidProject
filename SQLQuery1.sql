select * from PortofolioProject..coviddeaths
order by 3,4

--select * 
--FROM PortofolioProject..covidvaccinations
--ORDER BY 3,4

--select Data that we are going to be using


SELECT location, date, total_cases , new_cases, total_deaths, population
FROM PortofolioProject..coviddeaths
ORDER BY 1,2 

--Looking at Total Cases vs Total Deaths
-- shows lilelihood of dying if you contract covid in your country 
SELECT location, date, total_cases, total_deaths,(cast(total_deaths as decimal)/ cast(total_cases as decimal))*100 AS DeathPercentage
FROM PortofolioProject..coviddeaths
WHERE location like '%state%'
ORDER BY 1,2 


--Looking at Total Cases vs Population
--shows what percentage of population got Covid

SELECT location, date, total_cases, population,(total_cases/population) *100 AS percentPopulationInfected
FROM PortofolioProject..coviddeaths
--WHERE location like '%state%'
ORDER BY 1,2 

--Looking at Countries with Highest Infection Rate compared to Population 

SELECT location,  population, MAX(total_cases) as HighestInfectionCount ,MAX((total_cases/population)) *100 AS PercentagePopulationInfected
FROM PortofolioProject..coviddeaths
--WHERE location like '%state%'
GROUP BY location, population
ORDER BY PercentagePopulationInfected desc

--Showing Countries with Highest Death Count Per Population

SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortofolioProject..coviddeaths
--WHERE location like '%state%'
GROUP BY location
ORDER BY TotalDeathCount desc


--Let's Break Things Down By Continent

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortofolioProject..coviddeaths
--WHERE location like '%state%'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc

--Showing contintents with the highest death count per population

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortofolioProject..coviddeaths
--WHERE location like '%state%'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc

--Global Numbers

SELECT date, SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths ,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortofolioProject..coviddeaths
--WHERE location like '%state%'
WHERE continent is not null
GROUP BY date
ORDER BY 1,2 

--Looking at Total Population vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location,
dea.Date) as RollingPeopleVaccinated
,(RollingPeopleVaccinated /population)*100
from PortofolioProject..coviddeaths dea
join PortofolioProject..covidvaccinations vac
     ON dea.location= vac.location
	 and dea.date= vac.date
WHERE dea.continent is not null
ORDER BY 2,3


--Use CTE

with PopvsVac (continent, location, Date,population,new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location,
dea.Date) as RollingPeopleVaccinated
from PortofolioProject..coviddeaths dea
join PortofolioProject..covidvaccinations vac
     ON dea.location= vac.location
	 and dea.date= vac.date
WHERE dea.continent is not null
--ORDER BY 2,3
)
SELECT *
FROM PopvsVac

--Temp Table

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
DAte datetime,
Population numeric, 
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
INSERT INTO #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location,
dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortofolioProject..coviddeaths dea
join PortofolioProject..covidvaccinations vac
     ON dea.location= vac.location
	 and dea.date= vac.date
--WHERE dea.continent is not null
--ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated



--Creating View to store data  for later visulizations

CREATE View PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location,
dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortofolioProject..coviddeaths dea
join PortofolioProject..covidvaccinations vac
     ON dea.location= vac.location
	 and dea.date= vac.date
WHERE dea.continent is not null
--ORDER BY 2,3

SELECT *
FROM PercentPopulationVaccinated