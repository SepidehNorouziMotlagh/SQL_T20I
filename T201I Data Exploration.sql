select * from T20I

--Q1 Identify matches played between two specific teams (e.g., India and South Africa) in 2024 and their result

select * from T20I
where ((Team1='India' and Team2='South Africa') or (Team1='South Africa' and Team2='India'))
and year(MatchDate)=2024

--Q2 Find the team with the highest number of wins in 2024 and the total number of matches won

select Top 1 Winner, count(*) as 'Total Matches Won' 
from T20I where year(MatchDate)=2024
group by Winner order by 'Total Matches Won' desc

--Q3 Rank the teams based on the total number of wins in 2024

select Winner, count(*) as 'Total Matches Won',
DENSE_RANK() over (order by count(*) desc) as 'Rnak Assigned'
from T20I  where YEAR(MatchDate)=2024 and Winner not in ('tied', 'no result')
group by Winner

--Q4 Which team had the highest average winning margin (in runs), and what was the average margin?

select top 1 Winner,
avg(cast(substring(Margin, 1, CHARINDEX(' ', Margin)-1)as int)) as 'AvgMargin'
from T20I where Margin like '%runs'
group by Winner order by 'AvgMargin' desc

--Q5 List all matches where the winning margin was greater than the average margin across all matches

with cte_AvgMargin as (
select avg(cast (substring (Margin, 1, charindex(' ', Margin) -1) as int)) as OverallAvgMargin from T20I where Margin like '%runs')
select t.Team1, t.Team2, t.Winner, t.Margin from T20I t
left join cte_AvgMargin a on 1=1
where t.Margin like '%runs'
and cast(SUBSTRING(Margin, 1, charindex(' ', Margin)-1)as int) > a.OverallAvgMargin

--Q6 Find the team with the most wins when chasing a target (wins by wickets)

select Winner, WinWhileChasing from(
select Winner, count(*) as WinWhileChasing, rank() over (order by count(*) desc) as RankWickets
from T20I where Margin like '%wickets' and Margin not in ('tied','no result')
group by Winner) t
where RankWickets=1

--Q7 Head to head record between two selected teams (e.g., England vs Australia)

declare @TeamA varchar(25) ='England';
declare @TeamB varchar(25) = 'Australia';

select Winner, count(*) as Matches from T20I
where (Team1=@TeamA and Team2=@TeamB) or (Team2=@TeamA and Team1=@TeamB)
group by Winner

--Q8 Identify the month in 2024 with the highest number of T20I matches played

select top 1 YEAR(MatchDate) as YearOfMatch,
MONTH(MatchDate) as MonthOfMatch,
DATENAME(Month,MatchDate) as MonthName,
Count(*) as MatchesPlayed
from T20I
where year(MatchDate)=2024
group by year(MatchDate), MONTH(MatchDate), DATENAME(MONTH, MatchDate)
order by MatchesPlayed desc

--Q9 For each team, find how many matches they played in 2024 and their win percentage

with CTE_MatchesPlayed as (
select Team, count(*) as MatchesPlayed from(
select Team1 as Team
from T20I 
where year(MatchDate) = 2024
union all
select Team2 as Team 
from T20I
where YEAR(MatchDate) = 2024) t
group by Team),
CTE_Wins as (
select Winner as Team, count(*) as Wins
from T20I where YEAR(MatchDate)=2024 and Winner not in ('tied','no result')
group by Winner)

select m.Team, m.MatchesPlayed,
isnull(w.Wins, 0) as Wins, cast(isnull( w.wins * 100.0/m.MatchesPlayed,0) as decimal(10,2)) as WinPercentage
from CTE_MatchesPlayed m left join CTE_Wins w on m.Team = w.Team
order by WinPercentage desc

--Q10 Identify the most successfull team at each ground (team with most wins per ground)

with CTE_WinsPerGround as (
select Winner, Ground, Wins, RANK() over (partition by Ground order by Wins desc) as RN
from (
select Winner, Ground, COUNT(*) as Wins
from T20I where Winner not in ('tied','no result')
group by Winner,Ground) t ) 
select Ground, Winner as MostSuccessfull, Wins
from CTE_WinsPerGround
where RN = 1
order by Ground