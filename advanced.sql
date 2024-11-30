CREATE TABLE job_applied (
    job_id INT,
    application_sent_date DATE,
    custom_resume BOOLEAN,
    resume_file_name VARCHAR(255),
    cover_letter_sent BOOLEAN,
    cover_letter_file_name VARCHAR(255),
    status VARCHAR(50)
);

SELECT *, data_type
FROM information_schema.columns
WHERE table_name = 'job_applied';

INSERT INTO job_applied
            (job_id,
            application_sent_date,
            custom_resume,
            resume_file_name,
            cover_letter_sent,
            cover_letter_file_name,
            status)
VALUES
            (1,
            '2024-02-01',
            true,
            'resume_01.pdf',
            true,
            'cover_letter_01.pdf',
            'submitted'),
            (2,
            '2024-02-02',
            false,
            'resume_02.pdf',
            false,
            NULL,
            'interview scheduled'),
            (3,
            '2024-02-03',
            true,
            'resume_03.pdf',
            true,
            'cover_letter_03.pdf',
            'ghosted'),
            (4,
            '2024-02-04',
            true,
            'resume_04.pdf',
            false,
            NULL,
            'submitted'),
            (5,
            '2024-02-05',
            false,
            'resume_05.pdf',
            true,
            'cover_letter_05.pdf',
            'rejected');

ALTER TABLE job_applied
ADD contact VARCHAR(50);

UPDATE job_applied
SET contact = 'Erlich Bachman'
WHERE job_id = 1;

UPDATE job_applied
SET contact = 'Dinesh Chugtai'
WHERE job_id = 2;

UPDATE job_applied
SET contact = 'Bertram Gilfoyle'
WHERE job_id = 3;

UPDATE job_applied
SET contact = 'Jian Yang'
WHERE job_id = 4;

UPDATE job_applied
SET contact = 'Big Head'
WHERE job_id = 5;


ALTER TABLE job_applied
RENAME COLUMN contact TO contact_name;

ALTER TABLE job_applied
ALTER COLUMN contact_name TYPE TEXT;

ALTER TABLE job_applied
DROP COLUMN contact_name;

DROP TABLE job_applied;

SELECT job_posted_date
FROM job_postings_fact
LIMIT 5;

SELECT 
'2023-02-19'::DATE,
'123'::INTEGER,
'true'::BOOLEAN,
'3.14'::REAL;

SELECT 
job_title_short AS title,
job_location AS location, 
job_posted_date::DATE AS date
FROM
job_postings_fact

SELECT 
job_title_short AS title,
job_location AS location, 
job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time,
EXTRACT(MONTH FROM job_posted) AS date_month
EXTRACT(YEAR FROM job_posted) AS date_year
FROM
job_postings_fact
LIMIT 5;

SELECT
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM 
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY month
ORDER BY
    job_posted_count DESC;


SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 1
LIMIT 5;

CREATE TABLE january_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

SELECT job_posted_date
FROM january_jobs;

CREATE TABLE february_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

SELECT job_posted_date
FROM february_jobs;

CREATE TABLE march_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

SELECT job_posted_date
FROM march_jobs;

CREATE TABLE april_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 4;

SELECT job_posted_date
FROM april_jobs;

CREATE TABLE may_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 5;

SELECT job_posted_date
FROM may_jobs;

CREATE TABLE june_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 6;

SELECT job_posted_date
FROM june_jobs;

CREATE TABLE july_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 7;

SELECT job_posted_date
FROM july_jobs;

CREATE TABLE august_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 8;

SELECT job_posted_date
FROM august_jobs;

CREATE TABLE semptember_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 9;

SELECT job_posted_date
FROM semptember_jobs;

CREATE TABLE october_jobs AS
    SELECT *
    FROM job_postings_fact
        WHERE EXTRACT(MONTH FROM job_posted_date) = 10;

SELECT job_posted_date
FROM october_jobs;

CREATE TABLE november_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 11;

SELECT job_posted_date
FROM november_jobs;

CREATE TABLE december_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 12;

SELECT job_posted_date
FROM december_jobs;

SELECT
    job_title_short,
    job_location,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM  job_postings_fact;

SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    location_category;

SELECT *
FROM (
        SELECT *
        FROM job_postings_fact
        WHERE EXTRACT(MONTH FROM job_posted_date) = 1

) AS january_jobs;

SELECT 
    company_id,
    name AS company_name
FROM company_dim
WHERE company_id IN (
    SELECT
        company_id
    FROM
        job_postings_fact
    WHERE
        job_no_degree_mention = true
    ORDER BY company_id
);

WITH company_job_count AS (
SELECT
    company_id
    COUNT(*) AS total_jobs
FROM
    job_postings_fact
GROUP BY
    company_id
);

SELECT *
FROM company_job_count;

SELECT 
    company_dim.name AS company_name,
    company_job_count.total_jobs
FROM company_dim
LEFT JOIN company_job_count
    ON company_job_count.company_id = company_dim.company_id;

    WITH remote_job_skills AS  (
SELECT
    job_postings.job_id,
    skill_id,
    COUNT(*) AS skill_count
FROM
    skills_job_dim AS skills_to_job
INNER JOIN job_postings_fact AS job_postings
    ON job_postings.job_id = skills_to_job.job_id
WHERE
    job_postings.job_work_from_home = True
GROUP BY
    skill_id
);

SELECT
    skills.skill_id,
    skills AS skill_name,
    skill_count
FROM remote_job_skills
INNER JOIN skills_dim AS skills
    ON skills.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 5;

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs
UNION
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs
UNION
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    march_jobs;

SELECT
    quarter1_job_postings.job_title_short,
    quarter1_job_postings.job_location,
    quarter1_job_postings.job_via,
    quarter1_job_postings.job_posted_date::DATE,
    quarter1_job_postings.salary_year_avg
FROM (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
) AS quarter1_job_postings
WHERE
    quarter1_job_postings.salary_year_avg > 70000 AND
    quarter1_job_postings.job_title_short = 'Data Analyst'
ORDER BY
    quarter1_job_postings.salary_year_avg DESC;

SELECT
    job_title_short,
    job_location,
    job_via,
    job_posted_date::DATE,
    salary_year_avg
FROM (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
) AS quarter1_job_postings
WHERE
    quarter1_job_postings.salary_year_avg > 70000 AND
    quarter1_job_postings.job_title_short = 'Data Analyst'
ORDER BY
    quarter1_job_postings.salary_year_avg DESC;