
--*SHOWING ALL DATA FROM THE 'CovidDeaths' TABLE:

Select *
From PortfolioProjectAlex..CovidDeaths
order by 3,4


--*SHOWING ALL DATA FROM THE 'Covidvaccinations' TABLE:

Select *
From PortfolioProjectAlex..CovidVaccinations
order by 3,4


--Next, we have to *SELECT THE DATA WE ARE GOING TO BE USING

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProjectAlex..CovidDeaths
order by 1,2



--*SHOWING TOTAL CASES VS TOTAL DEATHS

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)
From PortfolioProjectAlex..CovidDeaths
order by 1,2

--Shows results like 0.0 something. Explains: to get a %, you have to multiply by 100. 
--Also, with that query, it generates a NoName column, so it's a good idea to add an alias, which he does in the by editing the query:

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProjectAlex..CovidDeaths
order by 1,2

--Now we have a name for the new table with the calculation and actual percentage values in it. 


--NEXT TASK: LOOK AT THE UNITED STATES ONLY. 

-- SHOWING LIKELYHOOD OF DYING OF COVID IF YOU ARE IN THE US
--*Because we can't be sure how the US is spelled, we try using the 'like' clasue with wildcards '%states"':

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProjectAlex..CovidDeaths
where location like '%states%'
order by 1,2

--NEXT TASK

--SHOWING TOTAL CASES VS POPULATION
--*Shows what percentage of population infected with Covid

Select Location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProjectAlex..CovidDeaths
where location like '%states%'
order by 1,2



--NEXT TASK: SHOW WITH HIGHEST INFECTIONS RATES (has to be total_cases/population)
--Alex comment: remove "date" - this is NOT date-specific, we are looking at MAX values, so:
-- 1) write "total_cases" as MAX(total_cases), and also enclose the "(total_cases/population)" into a MAX expression, 
--like MAX((total_cases/population))

Select Location, MAX(total_cases) as HighestInfectionCount, population, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProjectAlex..CovidDeaths
--where location like '%states%'
order by 1,2

--The above Produces an Error:
--"Msg 8120, Level 16, State 1, Line 49
--Column 'PortfolioProjectAlex..CovidDeaths.location' is invalid in the select list because it is not contained in either an aggregate function or the GROUP BY clause.
--Completion time: 2023-07-10T19:52:02.4917111-07:00"


--ALEX comment: we need to add a "Group by"! Edits the query to add the "Group by" clause

Select Location, MAX(total_cases) as HighestInfectionCount, population, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProjectAlex..CovidDeaths
--where location like '%states%'
Group by Location, population
order by 1,2

--The above one works, but orders by Location and Population. 
-- NEXT TASK: ORDER BY PercentPopulationInfected, IN DESC ORDER. Alex comments: I really wanna look at the highest.

Select Location, MAX(total_cases) as HighestInfectionCount, population, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProjectAlex..CovidDeaths
--where location like '%states%'
Group by Location, population
order by PercentPopulationInfected desc



--NEXT TASK: SHOW COUNTRIES WITH THE HIGHEST DEATH COUNT PER POPULATION

-- JANA: Below is how I would do it (before I saw what he did), but then, under it, I include his thought progression.

Select Location, population, MAX(total_deaths) as HighestDeathCount, MAX((total_deaths/population))*100 as PercentPopulationDied
From PortfolioProjectAlex..CovidDeaths
--where location like '%states%'
Group by Location, population
order by PercentPopulationDied desc

--That query worked, and it ordered countries starting from the country with the highest death to population ratio (Hungary). 

--ALEX's next executed query was (to my surprise): 

Select Location, MAX(total_deaths) as TotalDeathCount
From PortfolioProjectAlex..CovidDeaths
--where location like '%states%'
Group by location
Order by TotalDeathCount desc

--JANA: 
--That one worked as well, but not sure why he did this. It's a count, not a percentage... Why he removed population? Also not sure. 
--I think it is just he meant to just compare death counts between countries maybe? There output was: 2 columns, with Location and TotalDeathCount, first place Austria 9997. 

--ALEX: 
--ISSUE with the Query: he said: 'if you're seeing this, there might be a problem with the data type'. 
--EXPLANATION: Clicked on CovidDeaths table in the side panel, -> columns -> shows data types for all columns. TotalDeaths shows as varchart
--SOLUTION: you have to converst, etc CAST this as an INT (the workaround I was looking for). 
--Edits the query: 

Select Location, MAX(cast (total_deaths as int)) as TotalDeathCount
From PortfolioProjectAlex..CovidDeaths
--where location like '%states%'
Group by location
Order by TotalDeathCount desc

--ISSUE with the Data: Alex notes that some of the rows in the Location col are actually not countries but continents (issue with the data). 
--Scrolls back to the first query to show all the data to re-explore: 

Select *
From PortfolioProjectAlex..CovidDeaths
order by 3,4

--There, we see that there is the "continent" column, and the locations that are continents have the name of the continent in "location" and "NULL" in continent. 
--Edits query to only include the entries where location is NOT NULL: 

Select *
From PortfolioProjectAlex..CovidDeaths
where continent IS NOT NULL
order by 3,4

--Alex: :This can be helpful in the future, not helpful now, so we remove the "where" clause. 
-- Goes back to the next query and adds the "where continent is not null" clause to the query. Now the list does not include continents. 

Select Location, MAX(cast (total_deaths as int)) as TotalDeathCount
From PortfolioProjectAlex..CovidDeaths
--where location like '%states%'
where continent is not null
Group by location
Order by TotalDeathCount desc

--Suggests we re-write all the previous queries to sort by continent before moving on with the next part of queries. 

---------------------------------------------------------------------------------------------------

--LET'S BREAK THINGS DOWN BY CONTINENT 
--*(previously we were breaking down by Location). 

Select continent, MAX(cast (total_deaths as int)) as TotalDeathCount
From PortfolioProjectAlex..CovidDeaths
--where location like '%states%'
where continent is not null
Group by continent
Order by TotalDeathCount desc

--ALEX: Stops for a sec, thinks... What if we change to IS NULL instead of IS NOT NULL, and switch back to selecting Location (not continent)? 
-- And changes the query to:

Select location, MAX(cast (total_deaths as int)) as TotalDeathCount
From PortfolioProjectAlex..CovidDeaths
--where location like '%states%'
where continent is null
Group by location
Order by TotalDeathCount desc

--He figured this one on the fly, as he was recording the vid. This is THE RIGHT WAY. 
--But because he based the next project (Tableau vizzes) on these old queries, he goes back to grouping by continent (previous query) even though the results are not 100% accurate. 

Select continent, MAX(cast (total_deaths as int)) as TotalDeathCount
From PortfolioProjectAlex..CovidDeaths
--where location like '%states%'
where continent is not null
Group by continent
Order by TotalDeathCount desc


--*Explains: A drill-down in Tableau is when you click on North America, it then shows US & Canada etc
---------------------------------------------------------------------------------------------------------------

--NEXT PART: WRITE QUERIES FOR TABLEAU VISUALIZATIONS

--NEXT QUERY: Use the last query as a starting point: 

Select continent, MAX(cast (total_deaths as int)) as TotalDeathCount
From PortfolioProjectAlex..CovidDeaths
--where location like '%states%'
where continent is not null
Group by continent
Order by TotalDeathCount desc



--NEXT: CALCULATE GLOBAL NUMBERS

--1) Takes the DeathPercentage Query from earlier as a STARTING POINT: 
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProjectAlex..CovidDeaths
where location like '%states%'
order by 1,2

--2) Edits the query: 
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProjectAlex..CovidDeaths
--where location like '%states%'
where continent is not null
order by 1,2

--3) Removes Location from "Select". Comment: wanna look at GLOBAL numbers, we don't need location etc. 
Select date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProjectAlex..CovidDeaths
--where location like '%states%'
where continent is not null
order by 1,2

--*This one works, but produces weird results ordering by date (because the 2nd column (total cases) number are gonna be different, SO:

--4) We need to add a "Group by" clause:
Select date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProjectAlex..CovidDeaths
--where location like '%states%'
where continent is not null
Group by date
order by 1,2

--OOPS! ERROR!!! Why? Cause we are looking to select (show) multiple things, so we can not group JUST by date. 
--Need to start using aggregate functions on everything else:

--5) Removes the redundant columns from "Select", and adds a SUM calculation there instead to calc the total # of cases for each day (group by date). 

--SHOWS THE TOTAL NUMBER OF NEW CASES FOR EACH DAY: 

Select date, SUM(new_cases)
From PortfolioProjectAlex..CovidDeaths
where continent is not null
Group by date
order by 1,2

--Now, Wanna add the SUM for new_deaths to the query

Select date, SUM(new_cases), SUM (new_deaths)
From PortfolioProjectAlex..CovidDeaths
where continent is not null
Group by date
order by 1,2

--OOPS! ERROR again!! Why? Data Type ISSUE again. Look what data type "new_deaths" is? Yeah, you guessed it - varchar. 
--SOLUTION: Cast this as int: 

--SHOWS THE TOTAL NUMBER OF NEW CASES AND NEW DEATHS FOR EACH DAY:

Select date, SUM(new_cases), SUM(cast (new_deaths as int))
From PortfolioProjectAlex..CovidDeaths
Where continent is not null
Group by date
order by 1,2


--NEXT TASK: CALCULATE DEATH PERCENTAGE

--SHOWS THE % OF DEATHS AMONG NEW CASES: 

Select date, SUM(new_cases) as TotalCases, SUM(cast (new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProjectAlex..CovidDeaths
Where continent is not null
Group by date
order by 1,2

--Now, if we remove the "Group by" clause, and then, of course, remove "data" from "Select", we'll be looking at: 

--THE TOTAL # OF CASES, TOTAL # OF DEATHS, AND THE % OF DEATHS, GLOBALLY, TO THE DAY

Select SUM(new_cases) as TotalCases, SUM(cast (new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProjectAlex..CovidDeaths
Where continent is not null
--Group by date
order by 1,2

--Well done!! We're gonna use this for Tableau later. Now, let's move on. 


--NEXT: Explore the CovidVaccinations Table. 

Select *
From PortfolioProjectAlex..CovidVaccinations


--LETS JOIN THESE 2 TABLES TOGETHER
--*lets join them on location and date. 

Select *
From PortfolioProjectAlex..CovidDeaths dea
Join PortfolioProjectAlex..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date


--LOOKING AT THE TOTAL POPULATION VS VACCINATIONS

--JANA: This is MY ATTEMPT to write a query for that before I watch what he does :D FAIL. 

Select SUM(dea.population), SUM(cast(vac.total_vaccinations as int))
From PortfolioProjectAlex..CovidDeaths dea
Join PortfolioProjectAlex..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date

--This produces an ERROR. 
--ERROR MESSAGE: 
--Msg 8115, Level 16, State 2, Line 315
--"Arithmetic overflow error converting expression to data type int.
--Warning: Null value is eliminated by an aggregate or other SET operation.

--Completion time: 2023-07-16T19:03:04.0491458-07:00"


--ALEX: his way:

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProjectAlex..CovidDeaths dea
Join PortfolioProjectAlex..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
order by 1, 2, 3

--This runs, no errors, but there are all these continent data with NULLS and so on. Gotta weed out continents, so: 
--We EDIT THE QUERY: 

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProjectAlex..CovidDeaths dea
Join PortfolioProjectAlex..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
order by 1, 2, 3

--NEXT: Alex comments: we could add "total vaccinations" - there is such column, but...
--It's a Portfolio, so we wanna show off our MAD SKILLZ to Employers. So, we're not gonna choose the easiest way, and...
--We're going to do what's called a "ROLLING COUNT'. YAZ! FANCY AS FUCK! 

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location) | <- Cast / CONVERT might be used alternatively in this case, both will work. 
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location)
From PortfolioProjectAlex..CovidDeaths dea
Join PortfolioProjectAlex..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
order by 2, 3

--This one works, but it only outputs the total number of vaccinations for a given location in every row for that location, 
-- without doing the actual rolling count.  To make it an actual rolling count, we need to add an "order by" clause
--to the OVER (Partition by...) statement, and order by location AND DATE (!). That's when it actually does the rolling count. 

--ADDS A ROLLING COUNT OUTPUT IN THE OUTPUT COLUMN (RollingPeopleVaccinated)

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location) | <- Cast / CONVERT might be used alternatively in this case, both will work. 
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProjectAlex..CovidDeaths dea
Join PortfolioProjectAlex..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
order by 2, 3



--NEXT, we wanna show the % OF THE POPULATION THAT IS VACCINATED for each contry. 

--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
--From PortfolioProjectAlex..CovidDeaths dea
--Join PortfolioProjectAlex..CovidVaccinations vac
--     On dea.location = vac.location
--	 and dea.date = vac.date
--Where dea.continent is not null
--order by 2, 3

--This gives and ERROR - invalid column name RollingPeopleVaccinated. 
--Meaning: can't use the column that you haven't yet created in a calculation.


--SOLUTION: There are TWO WAYS: 



--1) USE CTE

	With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
	as
	(
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, 
	dea.Date) as RollingPeopleVaccinated
	--, (RollingPeopleVaccinated/population)*100
	From PortfolioProjectAlex..CovidDeaths dea
	Join PortfolioProjectAlex..CovidVaccinations vac
		 On dea.location = vac.location
		 and dea.date = vac.date
	Where dea.continent is not null
	--order by 2,3
	--Had to comment this out, cause was getting ERROR MESSAGE: 
	--Msg 1033, Level 15, State 1, Line 415
	--The ORDER BY clause is invalid in views, inline functions, derived tables, subqueries, and common table expressions, unless TOP, OFFSET or FOR XML is also specified.
	)
	Select *
	From PopvsVac


	--Now, let's modify the last query to show the calculation we need - % of people vaccinated: 

	--With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
	--as
	--(
	--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	--, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
	--From PortfolioProjectAlex..CovidDeaths dea
	--Join PortfolioProjectAlex..CovidVaccinations vac
	--	 On dea.location = vac.location
	--	 and dea.date = vac.date
	--Where dea.continent is not null
	--)
	--Select *, (RollingPeopleVaccinated/Population)*100
	--From PopvsVac

	--JANA: FAILED ATTEMPT SHOWS COUNTRIES WITH MAX % OF PEOPLE VACCINATED

	--With PopvsVac (Continent, Location, Population, New_Vaccinations, RollingPeopleVaccinated)
	--as
	--(
	--Select dea.continent, dea.location, dea.population, vac.new_vaccinations
	--, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location) as RollingPeopleVaccinated
	--From PortfolioProjectAlex..CovidDeaths dea
	--Join PortfolioProjectAlex..CovidVaccinations vac
	--     On dea.location = vac.location
	--	 and dea.date = vac.date
	--Where dea.continent is not null
	--)
	--Select *, (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated
	--From PopvsVac
	--Group by Location


--2) USE TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
--This is needed because if you first execute the query that involves creating a Table, and then change something within the subquery,
--it'll spit out an Error message saying that such a table in the DB. So you beat the system to that message and tell it what to do if table exists. 

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
	From PortfolioProjectAlex..CovidDeaths dea
	Join PortfolioProjectAlex..CovidVaccinations vac
		 On dea.location = vac.location
		 and dea.date = vac.date
	--Where dea.continent is not null

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


--NEXT>> CREATE A VIEW TO STORE DATA FOR LATER VISUALIZATIONS

USE PortfolioProjectAlex
GO
--Had to use this, even though Alex didn't have that, because I ran into an issue he didn't have: 
--The Query would run, but I was NOT ABLE to see the view on the list even after refreshing... 
-- Turns out, even though I had the msg confiming that the command was exected successfully, it must have created the view in some different database. 
-- This intro is to make sure the view is created in the right DB. 
Create View PercentPeopleVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) 
	as RollingPeopleVaccinated
	From PortfolioProjectAlex..CovidDeaths dea
	Join PortfolioProjectAlex..CovidVaccinations vac
		 On dea.location = vac.location
		 and dea.date = vac.date