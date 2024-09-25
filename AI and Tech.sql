-- create database tech;

-- AI Adoption and Its Impact:
--  Can we identify which AI tools contribute most to increased productivity and employee satisfaction across the all industry?"
SELECT 
      count(u.Attended_no) as Total_users,
      a.`Experience with AI Search Dev`,
      a.`AI Benchmark`
FROM ai AS a
JOIN work_status AS w ON a.a_id = w.c_id
JOIN users AS u ON u.u_no = w.c_id
GROUP BY a.`Experience with AI Search Dev`, a.`AI Benchmark`
ORDER BY Total_users desc,`Experience with AI Search Dev` asc
LIMIT 10;

-- Ai tools and industry along with jobsatisfaction
with cte as (SELECT 
      count(u.Attended_no) as Total_users,
      a.`Experience with AI Search Dev`,
      u.Industry,
      avg(w.`Job Satisfaction`)as Job_satisfaction,
      rank()over(partition by u.Industry order by count(u.Attended_no) desc ) as ranking
FROM ai AS a
JOIN work_status AS w ON a.a_id = w.c_id
JOIN users AS u ON u.u_no = w.c_id
GROUP BY a.`Experience with AI Search Dev`,u.Industry
ORDER BY Total_users desc,`Experience with AI Search Dev` asc)
select Total_users,`Experience with AI Search Dev`,Industry,Job_satisfaction from cte 
where `Experience with AI Search Dev` in ('ChatGPT','Bing AI','GitHub Copilot','Amazon Q');
-- Programming Experience and Learning Resources:
-- "Which learning resources are popular among developers across industries
with cte as (select
    COUNT(u.Attended_no) AS vote_for_resources,
    l.`Learning rescources` AS learning_resources,
    u.industry,
    rank()over(partition by  COUNT(u.Attended_no) order by COUNT(u.Attended_no)) as ranking
FROM 
    users AS u
JOIN 
    learning_way AS l 
    ON u.u_no = l.l_id -- Assuming u_no is the user ID and l_id matches it
JOIN 
    work_status AS w 
    ON u.u_no = w.c_id -- Assuming user ID links to work_status table
GROUP BY 
    l.`Learning rescources`, u.industry
ORDER BY 
   1 desc,2 asc)
   select vote_for_resources,learning_resources,industry 
   from cte
   where ranking between 1 and 5
   order by 1 desc;

-- Tool Usage and Developer Productivity:
-- "What are the most commonly used development tools 
select  distinct`Professional Language` , count(t_id) as users 
from tech_tools
where `Professional Language`!='Bash/Shell (all shells)' and `Professional Language`!='HTML/CSS'
group by `Professional Language`
order by users desc
limit 10;

-- most used ide
select  distinct`IDE Worked with` , count(t_id) as users from tech_tools
group by `IDE Worked with`
order by users desc
limit 10;

-- most used database
select  distinct`Most used Database` , count(t_id) as users 
from tech_tools
where `Most used Database`!='Elasticsearch'
group by `Most used Database`
order by users desc
limit 10;

-- Industry-Specific AI Concerns and Benefits:
-- "What are the primary concerns and perceived benefits of AI among professionals in different industries, 
with cte as (
select distinct u.industry,
count(*) as users
 from ai a
 join users as u on u.u_no=a.a_id
 where a.`AI Threat` = 'Yes'
 group by industry
 order by users desc)
 
 select sum(users) as AI_is_friend from cte;
 
--  Industry Adoption of Remote Work
SELECT 
    distinct u.industry,
    COUNT(w.`Work Location`) AS remote_workers,
    a.`AI Benchmark`,
    ROUND(AVG(w.`job satisfaction`), 1) AS avg_satisfaction
FROM work_status w
JOIN users u ON u.u_no = w.c_id
join ai as a on a.a_id=w.c_id
WHERE w.`Work Location` = 'Remote' 
GROUP BY u.industry, a.`AI Benchmark`
having COUNT(w.`Work Location`)>10
ORDER BY avg_satisfaction DESC;
