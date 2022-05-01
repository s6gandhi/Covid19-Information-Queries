
select location,population, date,total_cases ,total_deaths from portfolioproject_covid..['Covid Deaths$']
Where location != 'World'
order by 2 DESC

-- Likelihood of dying in India
select location, date,total_cases ,total_deaths,(total_deaths/total_cases) *100 AS MortalityRate 
from portfolioproject_covid..['Covid Deaths$']
where location like '%ind%'
order by 2 DESC

--Looking at countries with highest Infection rate 
select location,population, MAX(total_cases) AS Highest_Count ,MAX((total_cases/population))*100 AS highest_Infection_Percentage
from portfolioproject_covid..['Covid Deaths$']
Group by location,population
order by highest_Infection_Percentage DESC

select continent, MAX(cast(total_deaths as int)) as total_death from portfolioproject_covid..['Covid Deaths$']
where continent != 'NULL'
group by continent

--Looking at Total Population vs Vaccinations
select * from portfolioproject_covid..['Covid Deaths$'] d
join portfolioproject_covid..CovidVaccinations$ v
on d.location=v.location and d.date=v.date

--Rolling Sum of vaccinated people
select d.location,d.date,d.population,v.new_vaccinations,sum(CONVERT(bigint,v.new_vaccinations)) over (partition by d.location order by d.location,d.date) as Sumofpeoplevaccinated
from portfolioproject_covid..['Covid Deaths$'] d
join portfolioproject_covid..CovidVaccinations$ v
on d.location=v.location and d.date=v.date
where v.new_vaccinations!=0

--

With popsvsvac( location,date,population,new_vaccinations,Sumofpeoplevaccinated)
as(
select d.location,d.date,d.population,v.new_vaccinations,sum(CONVERT(bigint,v.new_vaccinations)) over (partition by d.location order by d.location,d.date) as Sumofpeoplevaccinated
from portfolioproject_covid..['Covid Deaths$'] d
join portfolioproject_covid..CovidVaccinations$ v
on d.location=v.location and d.date=v.date
where v.new_vaccinations!=0
)
Select location, population, max(new_vaccinations/population)*100 as PercentageofpeopleVaccinated from popsvsvac
group by location,population
order by PercentageofpeopleVaccinated desc


--temp table 

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Population numeric,
New_vaccinations numeric,
)

Insert into #PercentPopulationVaccinated
Select d.continent, d.location, d.population, v.new_vaccinations
From portfolioproject_covid..['Covid Deaths$'] d
Join portfolioproject_covid..CovidVaccinations$ v
	On d.location = v.location
	and d.date = v.date


Select *
From #PercentPopulationVaccinated

select * from PeopleVacinnated


-- creating view
go
Create View PeopleVacinnated as
select d.location,d.date,d.population,v.new_vaccinations,sum(CONVERT(bigint,v.new_vaccinations)) over (partition by d.location order by d.location,d.date) as Sumofpeoplevaccinated
from portfolioproject_covid..['Covid Deaths$'] d
join portfolioproject_covid..CovidVaccinations$ v
on d.location=v.location and d.date=v.date
where v.new_vaccinations!=0






