
CREATE table january as
    SELECT* FROM job_postings_fact
    WHERE EXTRACT(MONTH from job_posted_date) = 1;




CREATE table febuary as
    SELECT* FROM job_postings_fact
    WHERE EXTRACT(MONTH from job_posted_date) = 2;


CREATE table march as
    SELECT* FROM job_postings_fact
    WHERE EXTRACT(MONTH from job_posted_date) = 3;


select count(job_id) as number_of_jobs,
        /*job_title_short,
        job_location,*/
    case
        when job_location = 'Anywhere' then 'remote'
        when job_location = 'New York, NY' then 'local'
        else 'onsite'
    end as location_category
from   
    job_postings_fact
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY 
    location_category;


select name as company_name
from company_dim
where company_id in (
    select company_id
    from job_postings_fact
    WHERE job_no_degree_mention = true
)


CREATE TABLE job_applied(
    job_id INT,
    application_sent_date DATE,
    custom_resume 
)

WITH company_job_count AS (
    select 
        company_id,
        count(*) AS total_jobs
    from 
        job_postings_fact
    GROUP BY 
        company_id
    )
select 
    company_dim.name as company_name,
    company_job_count.total_jobs
from
    company_dim
left join company_job_count on company_job_count.company_id = company_dim.company_id
ORDER BY total_jobs DESC;



problem 7
with remote_job_skills as (
    select 
        skill_id,
        count(*) as skill_count
    from 
        skills_job_dim as skills_to_job
    inner join job_postings_fact as job_postings on job_postings.job_id = skills_to_job.job_id 
    WHERE job_postings.job_work_from_home = True and job_postings.job_title_short = 'Data Analyst'
    GROUP BY 
        skill_id
    )

select 
    skills.skill_id, 
    skills as skill_name, 
    skill_count 
from remote_job_skills
inner join skills_dim as skills on skills.skill_id = remote_job_skills.skill_id
ORDER BY skill_count DESC
limit 10



//UNION

select job_title_short,
    company_id,
    job_location
from january

UNION all

select job_title_short,
    company_id,
    job_location
from febuary

UNION all

select job_title_short,
    company_id,
    job_location
from march



problem 8
select 
    quarter1_job_posting.job_title_short,
    quarter1_job_posting.job_location,
    quarter1_job_posting.job_via,
    quarter1_job_posting.job_posted_date::DATE,
    quarter1_job_posting.salary_year_avg
from(
    select * from january
    UNION all
    select * from febuary
    union all
    select * from march
    ) AS quarter1_job_posting
where quarter1_job_posting.salary_year_avg > 70000 and 
    quarter1_job_posting.job_title_short = 'Data Analyst'
ORDER BY  quarter1_job_postings.salary_year_avg desc