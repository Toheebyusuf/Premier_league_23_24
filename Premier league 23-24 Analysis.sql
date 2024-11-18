--Query out the whole DataSet
select *
from [Premierleague23/24]


--Total Goals scored by each team ordering from the highest to the least

select Team, SUM(Gls) as Goal_scored_by_Team
from [Premierleague23/24]
group by Team
order by Goal_scored_by_Team Desc


--Total goals that had assist in it by each team ordering from the highest to the least

select Team, SUM(Ast) as Assists_by_team
from [Premierleague23/24]
group by Team
order by Assists_by_team Desc


--Goals scored by each players

select Player, Gls as Goals, Team
from [Premierleague23/24]
order by Gls Desc

--Assists made by each players to query out the TOP PLAYMAKERS

select Player, Ast as Assists, Team
from [Premierleague23/24]
order by Ast Desc


--Assists compared to their expected assists made by each players to query out the TOP PLAYMAKERS 
--and see how they faired to what was expected of them

select top 25 Player, Ast as Assits,xAG as Expected_Assists, Team
from [Premierleague23/24]
order by Ast Desc



--Goals Scored by each that played anywhere around the FW position ordering by minute played

select player, gls as Goals, pos as Position, Min as Minutes_played
from [Premierleague23/24]
where Pos like '%FW%'
order by Min desc





--Goals Scored by players from teams that finished in the top4

select player, gls as Goals, Team
from [Premierleague23/24]
where Pos not like '%gk%'and Team like 'Manchester city' or Team like 'Arsenal' or Team like 'Liverpool' or Team like 'Aston%' 
order by Goals desc


--Goals contributions by Forwards only

select Player,G_A as Goal_Contribution ,pos as Position, Team
from [Premierleague23/24]
where Pos like 'fw' 
order by Goal_Contribution desc


--goal contributions by forwards with at most 5 gaols contribution(G+A)  with aleast 5 games played

select Player,G_A as Goal_Contribution ,pos as Position, MP as Match_played, Min as Minutes_played, Team
from [Premierleague23/24]
where Pos like 'fw' and G_A <= 5 and MP >= 5
order by G_A desc


--goal contribtions by sheffield united forwards 

select Player,gls as GOALS,Ast as ASSITS, G_A as GOAL_CONTRIBUTION ,pos as POSITION, MP as Match_Played, Min as MINUTES_PLAYED
from [Premierleague23/24]
where Team = 'Sheffield United' and Pos like 'fw'
order by Gls desc


--goal contribtions by Goalkeepers 

select Player, G_A AS GOAL_CONTRIBUTION ,pos AS POSITION, MP AS MATCH_PLAYED, Min AS MINUTES_PLAYED, Team,Gls AS GOALS, Ast AS ASSITS
from [Premierleague23/24]
where Pos like 'gk'
order by G_A desc


--goals contributions(G+A) scored by defenders only

select Player, G_A ,pos, MP, Min, Team,Gls, Ast
from [Premierleague23/24]
where Pos like 'df'
order by Gls desc


--Relationship between xG and actual goals for players that excedded their xG

select Player, xG as expected_goals,Gls as goals, Gls-xG as xG_difference,Team
from [Premierleague23/24]
where Gls - xG > 1
order by xG_difference desc



--Relationship between xA and actual assists for players that excedded their xAG

select Player, xAG,Ast, Ast-xAG as xAG_difference,Team
from [Premierleague23/24]
where Ast - xAG > 1
order by xAG_difference desc




--Relationship between xG, xA and actual goals and assists for players that exceeded their xG + xAG
select Player, xG + xAG As Expected_goal_and_assist, G_A, G_A - (xG + xAG) As Expected_Goal_and_assist_diff,  Nation, Team
from [Premierleague23/24]
where G_A - (xG + xAG) > 1
order by Expected_Goal_and_assist_diff desc


--Average goals by team  considering only players with goals above 0
select Team, round(Avg(Gls),1) as Average_goals_by_team 
from [Premierleague23/24]
where Gls > 0
group by Team
order by Average_goals_by_team Desc


WITH CTE1 AS (
SELECT Team, sum(Gls) as Team_Total_Goals
FROM [Premierleague23/24]
GROUP BY Team),
CTE2 AS (
SELECT Player, Gls as Player_Total_Goals, Team
FROM [Premierleague23/24])
SELECT Player, Player_Total_Goals,  Team_Total_Goals, ROUND(100 * Player_Total_Goals/Team_Total_Goals,2) as goal_percent, CTE1.Team
FROM CTE1
JOIN CTE2
ON CTE2.Team = CTE1.Team
ORDER BY goal_percent DESC;

--Query to show the player whose goal was most impactful to their team

WITH Team_goals AS (
SELECT Team, sum(Gls) as Team_Total_Goals
FROM [Premierleague23/24]
GROUP BY Team),
Player_goals AS (
SELECT Player, Gls as Player_Total_Goals, Team
FROM [Premierleague23/24])
SELECT Player, Player_Total_Goals,  Team_Total_Goals, 
		ROUND(100 * Player_Total_Goals/Team_Total_Goals,2) as goal_percent, Team_goals.Team
FROM Team_goals
JOIN Player_goals
ON Player_goals.Team = Team_goals.Team
ORDER BY goal_percent DESC;


SELECT Player, Player_Total_Goals,  Team_Total_Goals, 
		ROUND(100 * Player_Total_Goals/Team_Total_Goals,2) as goal_percent, Team_goals.Team
FROM (SELECT Team, sum(Gls) as Team_Total_Goals
		FROM [Premierleague23/24]
		GROUP BY Team) as Team_goals
JOIN (SELECT Player, Gls as Player_Total_Goals, Team
		FROM [Premierleague23/24]) as Player_goals
ON Player_goals.Team = Team_goals.Team
ORDER BY goal_percent DESC;



SELECT 
    player, team, 
    ROUND((SUM(ast) / SUM(mp)) * 90, 2) AS ast_per_90,
    ROUND((SUM(gls) / SUM(mp)) * 90, 2) AS g_per_90
FROM [Premierleague23/24]
group by Player,Team
order by ast_per_90 desc
    