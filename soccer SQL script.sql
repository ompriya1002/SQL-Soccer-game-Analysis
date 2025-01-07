-- Create database to store the soccer data
Create database soccerdb;
use soccerdb;

-- 1. From the following table, write a SQL query to count the number of venues for EURO cup 2016. Return number of venues.**
SELECT COUNT(*)
FROM soccer_venue;

-- 2. From the following table, write a SQL query to count the number of countries that participated in the 2016-EURO Cup.
SELECT COUNT(DISTINCT team_id)
FROM player_mast;

-- 3. From the following table, write a SQL query to find the number of goals scored within normal play during the EURO cup 2016.
SELECT COUNT(*)
FROM goal_details;

-- 4. From the following table, write a SQL query to find the number of matches that ended with a result.
SELECT COUNT(*)
FROM match_mast
WHERE results='WIN';

-- 5. From the following table, write a SQL query to find the number of matches that ended in draws.
SELECT COUNT(*)
FROM match_mast
WHERE results='DRAW';

-- 6. From the following table, write a SQL query to find out when the Football EURO cup 2016 will begin.
SELECT play_date as "Beginning Date"
FROM match_mast
WHERE match_no=1;

-- 7. From the following table, write a SQL query to find the number of self-goals scored during the 2016 European Championship.
SELECT COUNT(*)
FROM goal_details
WHERE goal_type='O';

-- 8. From the following table, write a SQL query to count the number of players who were replaced during the stoppage time. Return number of players as "Player Replaced".
SELECT COUNT(*) as "Player Replaced"
FROM player_in_out
WHERE in_out='I'
AND play_schedule='ST';

-- 9. From the following table, write a SQL query to count the number of substitutes during various stages of the tournament. Sort the result-set in ascending order by play-half, play-schedule and number of substitute happened. Return play-half, play-schedule, number of substitute happened.
SELECT play_half, play_schedule, COUNT(*)
FROM player_in_out
WHERE in_out='I'
GROUP BY play_half, play_schedule
ORDER BY play_half, play_schedule, COUNT(*) DESC;

-- 10. From the following table, write a SQL query to count the number of penalty shots taken by each team. Return country name, number of shots as "Number of Shots".
SELECT a.country_name, COUNT(b.*) as "Number of Shots"
FROM soccer_country a, penalty_shootout b
WHERE b.team_id = a.country_id
GROUP BY a.country_name;

-- 11 From the following tables, write a SQL query to find the match number in which Germany played against Poland. Group the result set on match number. Return match number.
SELECT md.match_no
FROM match_details md
JOIN soccer_country sc ON md.team_id = sc.country_id
WHERE sc.country_name IN ('Germany', 'Poland')
GROUP BY md.match_no
HAVING COUNT(DISTINCT md.team_id) = 2;

-- 12.From the following tables, write a SQL query to find the highest audience match. Return country name of the teams.
SELECT country_name
FROM soccer_country
WHERE country_id IN (
       SELECT team_id
	   FROM goal_details
	   WHERE match_no = (
			SELECT match_no
            FROM match_mast
            WHERE audence = (
                  SELECT max(audence)
                  FROM match_mast))
ORDER BY audence DESC);

-- 13. From the following table, write a SQL query to find the second-highest stoppage time in the second half.
SELECT MAX(stop2_sec)
FROM match_mast
WHERE stop2_sec NOT IN (
    SELECT MAX(stop2_sec)
    FROM match_mast);
    
-- 14. From the following table, write a SQL query to find the club, which supplied the most number of players to the 2016-EURO cup. Return club name, number of players.
SELECT playing_club, mycount
FROM (
    SELECT playing_club, COUNT(playing_club) mycount,
           RANK() OVER (ORDER BY COUNT(playing_club) DESC) rnk
    FROM player_mast
    GROUP BY playing_club
) ranked
WHERE rnk = 1;

-- 15. From the following tables, write a  [**SQL query**](https://www.w3resource.com/sql-exercises/soccer-database-exercise/sql-subqueries-exercise-soccer-database-15.php#) to find the player who scored the first penalty in the tournament. Return player name,  [**Jersey**](https://www.w3resource.com/sql-exercises/soccer-database-exercise/sql-subqueries-exercise-soccer-database-15.php#) number and country name.
SELECT pm.player_name, pm.jersey_no, sc.country_name
FROM player_mast pm
JOIN goal_details gd1 ON pm.player_id = gd1.player_id
JOIN soccer_country sc ON pm.team_id = sc.country_id
WHERE gd1.goal_type = 'P'
  AND gd1.match_no = (
    SELECT MIN(gd2.match_no)
    FROM goal_details gd2
    WHERE gd2.goal_type = 'P' AND gd2.play_stage = 'G'
  )
GROUP BY pm.player_name, pm.jersey_no, sc.country_name;

-- 16. From the following table, write a SQL query to find the Liverpool players who were part of England's squad at the 2016 Euro Cup. Return player name, jersey number, and position to play, age.
SELECT player_name, jersey_no, posi_to_play, age
FROM player_mast
WHERE playing_club='Liverpool'
AND team_id=(
    SELECT country_id
    FROM soccer_country
    WHERE country_name='England');

-- 17. From the following table, write a SQL query to find out who was the captain of Portugal's winning EURO cup 2016 team. Return the captain name.
SELECT player_name
FROM player_mast
WHERE player_id IN (
    SELECT player_captain
    FROM match_captain
    WHERE  team_id=(
        SELECT team_id
        FROM match_details
        WHERE play_stage='F' AND win_lose='W'));

-- 18. From the following tables, write a SQL query to find the runners-up in Football EURO cup 2016. Return country name.
SELECT country_name
FROM soccer_country
WHERE country_id=(
       SELECT team_id
       FROM match_details
       WHERE play_stage='F' AND win_lose='L'
AND team_id<>(
        SELECT country_id
        FROM soccer_country
		WHERE country_name='Portugal'));
