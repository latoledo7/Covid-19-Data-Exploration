SELECT *
FROM `vivid-gantry-373101.portfolioproject.covid_deaths`
WHERE continent is not null
ORDER BY 3,4;

SELECT location, date, total_cases, new_cases, total_deaths, population,
FROM `vivid-gantry-373101.portfolioproject.covid_deaths`
WHERE continent is not null
ORDER BY 1,2; ##order by location and date

## Total cases vs total deaths
## Likelihood of dying from Covid

SELECT location,date, total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage ##calculate percentage of deaths 
FROM `vivid-gantry-373101.portfolioproject.covid_deaths`
WHERE location LIKE '%States%'
and continent is not null
ORDER BY 1,2;

## Total Cases vs Population
##percentage of population that got covid in US

SELECT location,date, total_cases, population,(total_cases/population)*100 as covid_percentage 
FROM `vivid-gantry-373101.portfolioproject.covid_deaths`
WHERE location LIKE '%States%'
ORDER BY 1,2;

##looking at countries with highest infection rate compared to population

SELECT location, population,MAX(total_cases) as Highest_Infection_Count, MAX((total_cases/population))*100 as Percent_Population_Infected 
FROM `vivid-gantry-373101.portfolioproject.covid_deaths`
WHERE continent is not null
Group BY location, population
ORDER BY Percent_Population_Infected DESC;

## Broken down by continent
##showing continent with highest death count
SELECT continent,MAX(cast(total_deaths as int)) as Total_Death_Count
FROM `vivid-gantry-373101.portfolioproject.covid_deaths`
WHERE continent is not null
Group BY continent
ORDER BY Total_Death_Count DESC;



## Global Numbers

SELECT date,SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as death_percentage
FROM `vivid-gantry-373101.portfolioproject.covid_deaths`
WHERE continent is not null
GROUP BY date
ORDER BY 1,2;


SELECT *
FROM vivid-gantry-373101.portfolioproject.covid_deaths dea
JOIN vivid-gantry-373101.portfolioproject.covid_vaccinations vac
  On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

SELECT 
  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CAST(vac.new_vaccinations as int)) OVER(Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM vivid-gantry-373101.portfolioproject.covid_deaths dea
JOIN vivid-gantry-373101.portfolioproject.covid_vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3;


With PopvsVac AS(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM vivid-gantry-373101.portfolioproject.covid_deaths dea
JOIN vivid-gantry-373101.portfolioproject.covid_vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

-- Creating View to store data for later visualizations

Create View vivid-gantry-373101.portfolioproject.PercentPopulationVaccinated AS(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
FROM vivid-gantry-373101.portfolioproject.covid_deaths dea
JOIN vivid-gantry-373101.portfolioproject.covid_vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL) 
