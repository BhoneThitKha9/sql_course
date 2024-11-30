--Order to Write Commands
/*
SELECT columns
FROM table_name
WHERE condition
GROUP BY column
HAVING condition
ORDER BY column
LIMIT number;
*/


SELECT *
FROM job_postings_fact;


SELECT *
FROM company_dim;


SELECT job_title_short, job_location
FROM job_postings_fact;


SELECT 
    job_postings_fact.job_title_short,
    job_postings_fact.job_location
FROM
    job_postings_fact;


SELECT
    job_title_short,
    job_location
FROM
    job_postings_fact
LIMIT 5;


SELECT DISTINCT
    job_title_short
FROM
    job_postings_fact;


SELECT DISTINCT
    salary_year_avg
FROM
    job_postings_fact;


SELECT
    job_title_short,
    job_location,
    job_via,
    salary_year_avg
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg ASC;


SELECT
    job_title_short,
    job_location,
    job_via,
    salary_year_avg
FROM
    job_postings_fact
WHERE
    salary_year_avg > 90000
ORDER BY
    salary_year_avg;


SELECT
    job_title_short,
    job_location,
    job_via,
    salary_year_avg
FROM
    job_postings_fact
WHERE
    salary_year_avg <> 'via Ai-jobs.net'


SELECT
    job_title_short,
    job_location,
    job_via,
    salary_year_avg
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst' 
    AND salary_year_avg > 100000
ORDER BY
    salary_year_avg;


SELECT
    job_title_short,
    job_location,
    job_via,
    salary_year_avg
FROM
    job_postings_fact
WHERE
    job_location IN ('Boston, MA', 'Anywhere') AND
    (
    (job_title_short = 'Data Analyst' AND salary_year_avg > 100000) 0R
    (job_title_short = 'Business Analyst' AND salary_year_avg > 80000)
    );


SELECT
    job_title_short,
    job_location,
    job_via,
    salary_year_avg
FROM
    job_postings_fact
WHERE
    job_title LIKE '%Business%Analyst%';


SELECT
    jpf.job_title_short AS job_title,
    jpf.job_location AS location,
    jpf.job_via AS online_platform,
    jpf.salary_year_avg AS salary
FROM
    job_postings_fact AS jpf
WHERE
    job_title LIKE '%Data%' OR job_title LIKE '%Business%' AND
    job_title LIKE '%Analyst%' AND
    job_title NOT LIKE '%Senior%';


SELECT
    SUM(salary_year_avg) AS salary_sum,
    COUNT(*) AS count_rows
FROM 
    job_postings_fact;


SELECT
    COUNT(DISTINCT job_title_short) AS job_type_total
FROM
    job_postings_fact;


SELECT
    job_title_short AS jobs,
    AVG(salary_year_avg) AS salary_avg,
    MIN(salary_year_avg) AS salary_min,
    MAX(salary_year_avg) AS salary_max
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    job_title_short;


SELECT
    job_title_short AS jobs,
    COUNT(job_title_short) AS job_count,
    AVG(salary_year_avg) AS salary_avg,
    MIN(salary_year_avg) AS salary_min,
    MAX(salary_year_avg) AS salary_max
FROM
    job_postings_fact
GROUP BY
    job_title_short
HAVING
    COUNT (job_title_short) > 100
ORDER BY
    salary_avg;


SELECT
    job_title_short,
    job_location,
    job_via,
    salary_year_avg
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg;


SELECT *
FROM skills_job_dim;


SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.company_id,
    cd.company_id,
    cd.name
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id;


SELECT
    jpf.job_id,
    jpf.job_title_short AS title
    cd.name AS company
FROM job_postings_fact AS jpf
RIGHT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id;


SELECT
    jpf.job_id,
    jpf.job_title_short AS job_title
    sjd.skill_id 
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim as sd
    ON sjd.skill_id = sd.skill_id;


SELECT
    sd.skills AS skill_name,
    COUNT(sjd.job_id) AS number_of_job_postings
FROM
    skills_dim AS sd
LEFT JOIN skills_job_dim AS sjd 
ON sd.skill_id = sjd.skill_id
GROUP BY
    sd.skills;


