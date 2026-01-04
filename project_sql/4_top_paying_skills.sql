/*
Answer : what are the top skills based on salary
- look at the average salary associated with each skills for Data Analyst Position
- focuses on role with specified salaries, regardless of location
- why? It reveals how different skills impact on salary for Data Analysts and 
    identify the most financially rewarding skills to acquire or improve
*/

SELECT 
    skills, 
    ROUND(AVG(salary_year_avg),0) as avg_salary
FROM 
    job_postings_fact
INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
    and job_work_from_home = 'True'
GROUP BY skills
ORDER BY avg_salary DESC
LIMIT 25