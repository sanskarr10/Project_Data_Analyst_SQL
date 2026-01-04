/*
Question : what are the most optimal skillsto learn (aka its in high demand and a high paying skills)?
- Identify skills om demand and assocaited with average salaries for Data Analyst role
- Concenrates on remote positions with specified salaries
- why? target skills that offer job security (high demand) and financial benefits (high salaries),
    offering strategic insights for career develpoment in Data Analysis
*/

WITH skills_demand AS (
    SELECT skills_dim.skill_id, skills_dim.skills, count(skills_job_dim.job_id) as demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Analyst' AND job_work_from_home = 'True'
        AND salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skill_id
), average_salary AS (
    SELECT 
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg),0) as avg_salary
    FROM 
        job_postings_fact
    INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
        and job_work_from_home = 'True'
    GROUP BY skills_job_dim.skill_id
)

SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM 
    skills_demand
INNER JOIN average_salary on skills_demand.skill_id = average_salary.skill_id
WHERE demand_count>10
ORDER BY avg_salary DESC, demand_count DESC
limit 25