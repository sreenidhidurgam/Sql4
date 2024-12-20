--Problem 1 : 
--The Number of Seniors and Juniors to Join the Company(https://leetcode.com/problems/the-number-of-seniors-and-juniors-to-join-the-company/)
 with cte as (
 select employee_id,experience,salary, sum(salary)over(partition by experience order by salary,employee_id) as r_sum
 from Candidates
 )
 select 'Senior' as experience, count(employee_id) as accepted_candidates from cte 
 where r_sum <= 70000 and experience = 'Senior'
 union
 select 'Junior' as experience, count(employee_id)as accepted_candidates from cte where experience = 'Junior' and r_sum <= (select 70000 - 
 ifnull(max(r_sum),0) as sum from cte where experience = 'Senior' and r_sum <= 70000)

 --Problem 2 : League Statistics(https://leetcode.com/problems/league-statistics/)
 WITH MatchResults AS (
    SELECT
        home_team_id AS team_id,
        home_team_goals AS goals_for,
        away_team_goals AS goals_against,
        CASE
            WHEN home_team_goals > away_team_goals THEN 3
            WHEN home_team_goals = away_team_goals THEN 1
            ELSE 0
        END AS points
    FROM Matches
    UNION ALL
    SELECT
        away_team_id AS team_id,
        away_team_goals AS goals_for,
        home_team_goals AS goals_against,
        CASE
            WHEN away_team_goals > home_team_goals THEN 3
            WHEN away_team_goals = home_team_goals THEN 1
            ELSE 0
        END AS points
    FROM Matches
)
SELECT
    t.team_name,
    COUNT(mr.team_id) AS matches_played,
    SUM(mr.points) AS total_points,
    SUM(mr.goals_for) AS goals_for,
    SUM(mr.goals_against) AS goals_against,
    SUM(mr.goals_for) - SUM(mr.goals_against) AS goal_difference
FROM
    MatchResults mr
    JOIN Teams t ON mr.team_id = t.team_id
GROUP BY
    t.team_name
ORDER BY
    total_points DESC,
    goal_difference DESC,
    t.team_name;

-- Problem 3 : Sales Person	(https://leetcode.com/problems/sales-person/)
Select s.name FROM salesperson s 
WHERE s.sales_id NOT IN(SELECT o.sales_id FROM Orders o
LEFT JOIN company c ON o.com_id = c.com_id
WHERE c.name='RED');

--Problem 4 : Friend Requests II(https://leetcode.com/problems/friend-requests-ii-who-has-the-most-friends/ )

WITH CTE AS(
    SELECT requester_id as r1
    FROM RequestAccepted
    UNION ALL
    SELECT accepter_id as r1
    FROM RequestAccepted
),
ACTE AS(
SELECT r1 as "id", COUNT(r1) AS 'num' FROM CTE GROUP BY r1)
SELECT id, num from ACTE order by num DESC LIMIT 1;


