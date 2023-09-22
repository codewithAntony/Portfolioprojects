select *
from portfolioproject..CovidDeaths
WHERE continent IS NOT NULL
order by 3,4

--select *
--from portfolioproject..CovidVaccinations
--order by 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
from portfolioproject..CovidDeaths
WHERE continent IS NOT NULL
order by 3,4


--Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DEATHPercentage
from portfolioproject..CovidDeaths
WHERE location like '%states%'
AND continent IS NOT NULL
order by 1, 2

--Looking at Total Cases vs Population
--Shows what percentage of population got covid
SELECT location, date, population, total_cases, (total_cases/population)*100 AS PopulationPercentageInfected
from portfolioproject..CovidDeaths
WHERE continent IS NOT NULL
--WHERE location like '%kenya%'
order by 1, 2

--Looking at countries with the highest infection rate compared to population
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PopulationPercentageInfected
from portfolioproject..CovidDeaths
--WHERE location like '%kenya%'
GROUP BY location, population
order by PopulationPercentageInfected DESC

--Showing Countries With Highest Death Count Per Population
SELECT location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
from portfolioproject..CovidDeaths
--WHERE location like '%kenya%'
WHERE continent IS NOT NULL
GROUP BY location
order by TotalDeathCount DESC

--Showing Continents With Highest Death Count Per Population
SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
from portfolioproject..CovidDeaths
--WHERE location like '%kenya%'
WHERE continent IS NOT NULL
GROUP BY continent
order by TotalDeathCount DESC

--GLOBAL NUMBERS

SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
--WHERE location like '%kenya%'
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2

--Look At Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3