/*
QUESTION 1: What are the top-paying data analyst jobs?
- Identify the top 10 highest-paying data analyst roles that are available remotely.
- Focuses on job postings with specified salaries (remove nulls).
- Why? To highlight the top-paying opportunities for data analysts, offering insights into employment opportunities.
*/

SELECT
    job_id,
        name AS company_name,
        job_title,
        job_schedule_type,
        salary_year_avg,
        job_posted_date
FROM 
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Data Analyst'
    AND job_work_from_home = TRUE
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;


/*
QUESTION 2: What skills are required for the top-paying data analyst jobs?
- Use the top 10 highest-paying data analyst jobs from the first query.
- Add specific skills required for these roles.
- Why? To provide a detailed look at which high-paying jobs demand certain skills,  
    helping job seekers understand which skills to develop that align with top salaries
*/

WITH top_paying_jobs AS (

    SELECT
        job_id,
        name AS company_name,
        job_title,
        salary_year_avg
    FROM 
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE 
        job_title_short = 'Data Analyst'
        AND job_work_from_home = TRUE
        AND salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;


/*
QUESTION 3: What are the most in-demand skills for data analysts?
- Identify the top 5 in-demand skills for remote data analyst positions.
- Why? To retrieve the top 5 skills with the highest demand in the job market, 
    providing insights into the most valuable skills for job seekers.
*/

SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND job_work_from_home = TRUE
    AND salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY 
    demand_count DESC
LIMIT 5;


/*
QUESTION 4: What are the top skills based on salary?
- Look at the average salary associated with each skill for data analyst positions.
- Focuses on roles with specified salaries for remote data analyst positions.
- Why? To reveal how different skills are associated with salary levels for data analysts 
    and help identify the most financially rewarding skills to acquire or improve on.
*/

SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS skill_count,
    ROUND(AVG(salary_year_avg),2) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
     job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE

GROUP BY 
    skills
HAVING 
    COUNT(skills_job_dim.job_id) >= 5
ORDER BY
    avg_salary DESC
LIMIT 25;


/*
QUESTION 5: What job skills are in high demand and associated with higher pay?
- Identify skills in high demand associated with higher average salaries for data analyst roles.
- Concentrates on remote positions with specified salaries.
- Why? To target skills that offer financial benefits, offering strategic 
    insights for career development.
*/

SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(salary_year_avg),2) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
     job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;


/*
QUESTION 6: How does data analyst hiring activity vary by month?
- Look at the number of data analyst roles posted by companies over the course of a year.
- Includes data analyst roles in all locations
- Why? To explore seasonal hiring patterns for data analyst positions.
*/

SELECT
    COUNT(job_id) AS job_count,
    DATE_TRUNC('month', job_posted_date) AS month
FROM
    job_postings_fact 
WHERE 
    job_title_short = 'Data Analyst'
    AND EXTRACT(YEAR FROM job_posted_date) = 2023
GROUP BY 
    month
ORDER BY
    month;


/*
QUESTION 7: What is the month-over-month percentage change in hiring activity?
- Analyze monthly changes in data analyst jobs posted throughout 2023.
- Compares each month's posting volume to the previous month
- Calculate the percent change in monthly postings.
- Why? Quantifies fluctuations in hiring activity to identify
    demand for data analysts.
*/

WITH monthly_jobs AS (
    SELECT
        COUNT(job_id) AS job_count,
        DATE_TRUNC('month', job_posted_date) AS month
    FROM
        job_postings_fact 
    WHERE 
        job_title_short = 'Data Analyst'
        AND EXTRACT(YEAR FROM job_posted_date) = 2023
    GROUP BY 
        month
), 
monthly_comparison AS (
    SELECT
        month,
        job_count,
        LAG(job_count) OVER (ORDER BY month) AS previous_month_count
    FROM
        monthly_jobs
)

SELECT 
    month,
    job_count,
    previous_month_count,
    ROUND(
        (job_count - previous_month_count) * 100.0 /
        NULLIF(previous_month_count, 0),
        2
    ) AS monthly_change_pct
FROM 
    monthly_comparison
ORDER BY 
    month;


/*
QUESTION 8: Which companies offer the most competitive salaries for data analysts?
- Identifies the 25 companies offering the highest average advertised salaries for data analysts.
- Only includes companies with 5 or more postings to allow for more accurate salary averages.
- Why? To identify employers offering highest average pay for data analyst roles and help job seekers
    prioritize potential employment opportunities. 
*/

SELECT
    company_dim.name AS company_name,
    COUNT(job_id) AS job_count,
    ROUND(AVG(salary_year_avg), 2) AS avg_salary
FROM 
    job_postings_fact
INNER JOIN
    company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    salary_year_avg IS NOT NULL
    AND job_title_short = 'Data Analyst'
GROUP BY
    company_dim.company_id,
    company_dim.name
HAVING 
    COUNT(job_id) >= 5
ORDER BY 
    avg_salary DESC
LIMIT 25;


/*
QUESTION 9: How do salaries differ between remote and non-remote data analyst positions?
- Compares the average advertised salaries for remote and non-remote data analyst roles.
- Only includes postings with reported annual salaries.
- Why? To examine whether remote positions are associated with higher
    or lower advertised salaries compared to non-remote positions.
*/

SELECT
    CASE
        WHEN job_work_from_home = FALSE THEN 'Non-Remote'
        WHEN job_work_from_home = TRUE THEN 'Remote'
        ELSE 'Unknown'
    END AS job_type,
    COUNT(job_id) AS job_count,
    ROUND(AVG(salary_year_avg), 2) AS avg_salary
FROM 
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
    AND job_title_short = 'Data Analyst'
GROUP BY
    job_work_from_home;


/*
QUESTION 10: Which countries have the greatest demand for data analysts?
- Aggregates the number of data analyst positions posted by country.
- Limits results to the top 25 countries by posting volume.
- Why? To explore the geographic distribution of data analyst employment
    opportunities and identify markets with high posting activity.
*/

SELECT
    job_country,
    COUNT(job_id) AS job_count
FROM 
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
    AND job_country IS NOT NULL
GROUP BY
    job_country
ORDER BY
    job_count DESC
LIMIT 25;