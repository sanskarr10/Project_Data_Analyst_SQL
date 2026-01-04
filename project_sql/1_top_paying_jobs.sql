/*Question : what are the top Paying Data Analyst jobs?
--Identify the top 10 Highest-Paying Data Analyst Job that are availbale remotely.
--focus on job posting with speecified salaries remove null.
--why> highlight the top paying oppounities for data analyst and offering insight 
*/

SELECT 
    job_id,
    job_location,
    job_title,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    Name as company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE job_title_short = 'Data Analyst' AND job_location = 'Anywhere' AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10