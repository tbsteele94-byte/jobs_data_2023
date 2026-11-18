# Data Analyst Job Market Analysis Using SQL


## Project Overview

This project explores the Data Analyst job market using SQL to examine advertised salaries, technical skill requirements, hiring trends, and geographic distribution.

The goal is to identify patterns that can help job seekers better understand the employment market, including which skills are frequently requested, which skills are associated with higher salaries, and how job posting activity changes over time.

The analysis consists of 10 SQL queries covering several aspects of the Data Analyst job market.


## Tools and Technologies

- PostgreSQL: Data querying and analysis
- SQL: Joins, aggregations, Common Table Expressions (CTEs), window functions, and conditional logic
- Visual Studio Code: Query development and organization

## Dataset

The analysis uses a relational database containing job postings, company information, and associated technical skills.

Four tables were used:

| Table | Description |
| --- | --- |
| job_postings_fact | Job titles, locations, salaries, posting dates, and remote-work indicators |
| company_dim | Company information |
| skills_dim | Technical skills associated with job postings |
| skills_job_dim | Relationships between job postings and required skills |

The dataset includes job posting records from all of 2023.

Data source: Data comes from publicly available datasets on datanerd.tech. This website pulls job postings from Google Jobs search results via SerpiApi, providing up-to-date records of data-related job postings.

Data Availability: The original CSV datasets are not included in this repository due to file size limitations. The data, along with the database and table creation queries, can be found in the Google Drive folder: https://drive.google.com/drive/folders/1i_pIIXfqmrl9EhULMtp38S6wtotb3aOC?usp=sharing

## Analytical Questions


### 1. Salary and Skill Requirements

- What are the 10 highest-paying remote Data Analyst positions?
- Which skills are required for these positions?
- What are the five most frequently requested skills for remote Data Analysts?
- Which skills are associated with the highest average advertised salaries?
- Which skills combine substantial demand with higher advertised salaries?

### 2. Hiring Trends

- How does Data Analyst job posting activity vary by month?
- What is the month-over-month percentage change in job postings during 2023?

### 3. Employers, Remote Work, and Geography

- Which companies advertise the highest average Data Analyst salaries among employers with at least five salary-reporting postings?
- How do advertised salaries compare between remote and non-remote positions?
- Which countries have the highest number of Data Analyst job postings?

## Methodology

SQL queries were developed to filter, aggregate, and compare job posting data.

The analysis included:

- Joining job postings with company and skill information.
- Excluding missing salary values from salary calculations.
- Calculating average advertised salaries and posting frequencies.
- Applying minimum posting-count thresholds to selected salary comparisons.
- Using CTEs and the LAG() window function to calculate month-over-month changes.
- Using CASE statements to categorize remote and non-remote positions.
- The analysis of remote positions was conducted separately from broader comparisons involving all available locations.

## Key Findings


### Technical Skills

| skills | demand_count |
| --- | --- |
| sql | 398 |
| excel | 256 |
| python | 236 |
| tableau | 230 |
| r | 148 |

When looking at remote postings for Data Analysts, SQL, Excel, Python, Tableau, and R rank among the most frequently requested skills from employers. SQL is the most in-demand skill, being about 55% more in-demand than the second most in-demand skill, Excel. Skills like pandas, numpy, and databricks are in lower demand, but are often associated with higher salaries, as explored in question 4. Question 5 identified Go, Confluence, and Hadoop as the skills associated with the highest average salaries among those appearing in more than ten salary-reporting remote postings.


### Salary Trends

| job_type | job_count | avg_salary |
| --- | --- | --- |
| Non-Remote | 4859 | 93764.65 |
| Remote | 604 | 94769.86 |

On average, based on the data available, remote work in 2023 paid about $1,000 more a year than non-remote work (in-person or hybrid work). That being said, there were about 8 times more postings with salary information for non-remote work than remote work. The 10 highest salaries for remote Data Analysts in 2023 ranged from $650,000 - $184,000. It is possible that the $650,000 posting from Mantys is in error, as this outlier is almost 2 times higher than the second-highest salary from Meta at $336,500. Additionally, the Mantys posting is for a Data Analyst, while the Meta posting is for a Director of Analytics. Several of the highest-paying postings were for senior-level positions, including Principal Data Analyst, Director of Analytics, and Associate Director roles. This suggests that experience level may be an important factor when interpreting the highest advertised salaries.

For all postings with advertised salaries, Intuit, Meta, and TikTok offered the highest average salaries for Data Analyst roles in 2023 at $178,571.43, $169,444.44, and $157,418.38 respectively. Interestingly, TikTok had the highest number of postings of the three at 46, with Intuit having 7 and Meta having 9. Of the 25 companies with the highest average advertised salaries for Data Analysts, Citi had the highest job count at 90 job postings. This could higher, however, because the company is actually listed twice as Citi and Citigroup, Inc.


### Hiring Activity

| Month | Job Postings | Previous Month | Monthly Change Percent |
| --- | --- | --- | --- |
| January | 23697 |  |  |
| February | 16479 | 23697 | -30.46 |
| March | 16342 | 16479 | -0.83 |
| April | 15499 | 16342 | -5.16 |
| May | 13457 | 15499 | -13.18 |
| June | 15932 | 13457 | 18.39 |
| July | 16150 | 15932 | 1.37 |
| August | 18602 | 16150 | 15.18 |
| September | 14997 | 18602 | -19.38 |
| October | 16260 | 14997 | 8.42 |
| November | 15133 | 16260 | -6.93 |
| December | 13560 | 15133 | -10.39 |

Of all Data Analyst jobs posted in 2023, including remote and non-remote postings and postings without advertised salaries, January, August and February saw the highest number of job postings. January had 23,697 jobs posted, being about 27% higher than August’s 18,602. Even though February was the month with the third highest amount of postings at 16,479, it also accounts for the most drastic percent change in 2023, with its job postings being about 30% lower than January’s. It is possible that January and February being two of the three busiest months for hiring in 2023 was due to the New Year having started and companies coming back to work from the holidays. The same could potentially be said for August, where companies could be resuming regular activity after the summer months.

December and May saw the fewest job postings in 2023, at 13,560 and 13,457 respectively. December’s decline can perhaps be consistent with reduced hiring activity during the winter months. The reasons for May’s lower volume are less clear. Additional years of data would help establish if this is a recurring seasonal pattern or something unique to 2023.


### Geographic Distribution

| job_country | job_count |
| --- | --- |
| United States | 67956 |
| France | 13855 |
| United Kingdom | 10509 |

The United States saw the highest number of all Data Analyst jobs posted, regardless of work type (remote or non-remote) or whether a salary was posted or not, at 67,956. This is about 390% higher than the second-place result, France, with 13,855 jobs posted. While this difference is drastic, it is worth noting that this job data only accounts for roles posted in English, making comparison to non-English speaking countries difficult. The United Kingdom had the third highest number of job postings in 2023, with 10,509, about 6.5 times lower than the number of postings in the United States


## Limitations

Several limitations should be considered when interpreting these findings:

- Salary comparisons include only postings with available annual salary information.
- Advertised salaries may differ from actual compensation.
- The number of job postings is a measure of observed posting activity, not a direct measure of total labor-market demand.
- Some analyses focus exclusively on remote positions, while others include all locations.
- International results only account for postings in English.
- Historical patterns from 2023 should not be assumed to represent current hiring conditions.

## Conclusion

This project demonstrates how SQL can be used to explore employment market data and answer practical questions about salaries, technical skills, hiring activity, and geographic trends. The analysis highlights the importance of considering both job posting frequency and salary information when evaluating employment opportunities.


## Files

**[sql_load](https://drive.google.com/drive/folders/14gxHJyMQ3PDvDjBq8wByBcfY74auZPFn?usp=sharing)**

- `1_create_database.sql` — sql code to create the jobs_data database
- `2_create_tables.sql` — sql code to create the company_dim, job_postings_fact, skills_dim, and skills_job_dim tables
- `3_modify_tables` — sql code to load csv data into tables

**[csv_files](https://drive.google.com/drive/folders/1FdNunttRCa7NbOj6MiVJnDWndFWFlaLh?usp=sharing)**

- `company_dim.csv` — data to build the company_dim table
- `job_postings_fact.csv` — data to build the job_postings_fact table
- `skills_dim.csv` — data to build the skills_dim table
- `skills_job_dim.csv` — data to build the skills_job_dim table

**[SQL Job Market Analysis Queries](1_jobs_data_2023_queries.sql)**

**[SQL Query Results](2_query_results.xlsx)**
