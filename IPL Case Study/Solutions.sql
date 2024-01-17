-- Questions and Queries
-- Before proceeding, let's add foreign key references to connect both the tables.
alter table deliveries add constraint fk_deliveries_matches foreign key (match_id) references matches(id);

-- Q1. WHAT ARE THE TOP 5 PLAYERS WITH THE MOST PLAYER OF THE MATCH AWARDS?
-- Printed Top 7 as last 4 players got same number of P0M awards.
select distinct player_of_match, count(player_of_match) over(partition by player_of_match) as No_of_POM
from matches order by No_of_POM desc limit 7;


-- Q2. HOW MANY MATCHES WERE WON BY EACH TEAM IN EACH SEASON?
select season, winner, count(winner) as No_of_Wins from matches group by season, winner;

-- As number of wins in each season is not ordered, I wanted to order them in descending order for each season.

with t1 as(
select season, winner, count(winner) as No_of_Wins from matches group by season, winner having season = 2017 order by No_of_Wins desc),
t2 as(
select season, winner, count(winner) as No_of_Wins from matches group by season, winner having season = 2009 order by No_of_Wins desc),
t3 as(
select season, winner, count(winner) as No_of_Wins from matches group by season, winner having season = 2008 order by No_of_Wins desc)
select * from t1 union select * from t2 union select * from t3;


-- Q3. WHAT IS THE AVERAGE STRIKE RATE OF BATSMEN IN THE IPL DATASET?
select avg(strike_rate) as Average_SR from 
(select batsman, 100*sum(total_runs)/count(ball) as strike_rate from deliveries group by batsman) as Average;


-- Q4. WHAT IS THE NUMBER OF MATCHES WON BY EACH TEAM BATTING FIRST VERSUS BATTING SECOND?
-- Creating a view of teams which elected to bat first and won the match. Binary indicator for win and loss
create view bat_first_winners as
select toss_winner, winner, toss_decision, case when toss_winner = winner then 1 else 0 end as result 
from matches where toss_decision = 'bat';
-- Checking the created view
select * from bat_first_winners;
-- Group by query
select winner, sum(result) as Total_Bat_First_and_Wins from bat_first_winners group by winner order by Total_Bat_First_and_Wins desc; 

-- Creating a view of teams which elected to field first and won the match. Binary indicator for win and loss
create view bat_second_winners as
select toss_winner, winner, toss_decision, case when toss_winner = winner then 1 else 0 end as result 
from matches where toss_decision = 'field';
-- Checking the created view
select * from bat_second_winners;
-- Group by query
select winner, sum(result) as Total_Bat_Second_and_Wins from bat_second_winners group by winner order by Total_Bat_Second_and_Wins desc;


-- Q5. WHICH BATSMAN HAS THE HIGHEST STRIKE RATE (MINIMUM 200 RUNS SCORED)?
select batsman, sum(total_runs) as Total_Runs, count(ball) as Balls_Faced, 100*sum(total_runs)/count(ball) as SR
from deliveries group by batsman having Total_Runs > 200 order by SR desc limit 1;


-- Q6. HOW MANY TIMES HAS EACH BATSMAN BEEN DISMISSED BY THE BOWLER 'MALINGA'?
select player_dismissed, bowler, count(player_dismissed) as No_of_dismissals 
from deliveries group by player_dismissed, bowler having (bowler like '%Malinga') and (player_dismissed is not null);


-- Q7. WHAT IS THE AVERAGE PERCENTAGE OF BOUNDARIES (FOURS AND SIXES COMBINED) HIT BY EACH BATSMAN?
select batsman, 100*avg(case when (batsman_runs=4) or (batsman_runs=6) then 1 else 0 end) as percentage_boundaries
from deliveries group by batsman;


-- Q8. WHAT IS THE AVERAGE NUMBER OF BOUNDARIES HIT BY EACH TEAM IN EACH SEASON?
select a.season, b.batting_team, 
avg(case when (b.batsman_runs=4) or (b.batsman_runs=6) then 1 else 0 end) as Avg_No_Boundaries
from matches a join deliveries b on a.id = b.match_id group by a.season, b.batting_team;


-- Q9. WHAT IS THE HIGHEST PARTNERSHIP (RUNS) FOR EACH TEAM IN EACH SEASON?
with t1 as (
select a.season as Season, b.batting_team as Team, b.batsman as Batsman, 
b.non_striker as Non_Striker, sum(b.batsman_runs) as One_Way_Partnership
from matches a join deliveries b on a.id = b.match_id 
where b.player_dismissed is null group by a.season, b.batting_team, b.batsman, b.non_striker),

t2 as (
select Season, Team,
case when Batsman > Non_Striker then Batsman else Non_Striker end as player1,
case when Batsman > Non_Striker then Non_striker else Batsman end as player2,
sum(One_Way_Partnership) as Partnership_Runs
from t1 group by Season, Team, player1, player2)

select Season, Team, max(Partnership_Runs) as Highest_Partnership
from t2 group by Season, Team;


-- Q10. HOW MANY EXTRAS (WIDES & NO-BALLS) WERE BOWLED BY EACH TEAM IN EACH MATCH?
-- Since mentioned only wides and no-balls, I have considered only these 2 and ignored others like legbye_runs.
select match_id, bowling_team, sum(wide_runs + noball_runs) as WD_NB_Extras
from deliveries where (wide_runs <> 0) or (noball_runs <> 0) group by match_id, bowling_team;


-- Q11. WHICH BOWLER HAS THE BEST BOWLING FIGURES (MOST WICKETS TAKEN) IN A SINGLE MATCH?
select a.match_id, a.bowler, count(a.bowler) as Wickets_Taken from (
select match_id, bowler, player_dismissed from deliveries where player_dismissed is not null) a
group by a.match_id, a.bowler order by Wickets_Taken desc limit 1;


-- Q12. HOW MANY MATCHES RESULTED IN A WIN FOR EACH TEAM IN EACH CITY?
select city, winner, count(id) as No_of_Wins from matches group by city, winner order by city;


-- Q13. HOW MANY TIMES DID EACH TEAM WIN THE TOSS IN EACH SEASON?
select season, toss_winner, count(toss_winner) No_of_Toss_Wins from matches group by season, toss_winner;


-- Q14. HOW MANY MATCHES DID EACH PLAYER WIN THE "PLAYER OF THE MATCH" AWARD?
select player_of_match, count(id) as No_of_POMs from matches group by player_of_match order by No_of_POMs desc;


-- Q15. WHAT IS THE AVERAGE NUMBER OF RUNS SCORED IN EACH OVER OF THE INNINGS IN EACH MATCH?
select match_id as Match_No, over_no, avg(total_runs) as Avg_Runs_Scored from deliveries group by match_id, over_no;


-- Q16. WHICH TEAM HAS THE HIGHEST TOTAL SCORE IN A SINGLE MATCH?
select match_id, batting_team, sum(total_runs) as Total_Score 
from deliveries group by match_id, batting_team order by Total_Score desc limit 1;


-- Q17. WHICH BATSMAN HAS SCORED THE MOST RUNS IN A SINGLE MATCH?
select match_id, batsman, sum(batsman_runs) as Batsman_Runs
from deliveries group by match_id, batsman order by Batsman_Runs desc limit 1;
