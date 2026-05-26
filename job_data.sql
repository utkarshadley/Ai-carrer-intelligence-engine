-- create database cleaned_data;

-- BASIC INFROMATIONS:
-- 1. Avg Salary
SELECT AVG(salary) AS avg_salary FROM job_data;

-- 2. Salary by Job Role

SELECT job_title, AVG(salary) 
FROM job_data
GROUP BY job_title
ORDER BY AVG(salary) DESC;

-- 3. Experience vs Salary
SELECT experience_years, AVG(salary)
FROM job_data
GROUP BY experience_years
ORDER BY experience_years desc;

-- 4.Top Paying Industry
SELECT industry, AVG(salary)
FROM job_data
GROUP BY industry
ORDER BY AVG(salary) DESC;

-- ADVANCED SQL
-- 1.Rank jobs by salary
SELECT 
    job_title,
    AVG(salary) AS avg_salary,
    RANK() OVER (ORDER BY AVG(salary) DESC) AS salary_rank
FROM job_data
GROUP BY job_title;
-- Insight:
--  Top paying roles identify 

-- 2. Running Average (Trend Analysis)
SELECT 
job_title,
    experience_years,
    AVG(salary) AS avg_salary,
    AVG(AVG(salary)) OVER (ORDER BY experience_years) AS running_avg
FROM job_data
GROUP BY experience_years,job_title;

-- 3. Partition By (Group-wise analysis )
SELECT 
    job_title,
    company_size,
    AVG(salary) OVER (PARTITION BY company_size) AS avg_salary_by_size
FROM job_data;

-- 4. CTE (Common Table Expression) 

--  Clean + readable queries

WITH avg_salary_cte AS (
    SELECT job_title, AVG(salary) AS avg_salary
    FROM job_data
    GROUP BY job_title
)
SELECT * 
FROM avg_salary_cte
WHERE avg_salary > 80000;

-- 5. Subquery (Nested Analysis)
SELECT job_title, salary
FROM job_data
WHERE salary > (
    SELECT AVG(salary) FROM job_data
);
-- 6. Case Statement (Classification 🔥)
SELECT 
    job_title,
    salary,
    CASE 
        WHEN salary < 50000 THEN 'Low'
        WHEN salary BETWEEN 50000 AND 100000 THEN 'Medium'
        ELSE 'High'
    END AS salary_category
FROM job_data;

-- 7.Top N Query (Advanced Filter)
SELECT job_title, AVG(salary) AS avg_salary
FROM job_data
GROUP BY job_title
ORDER BY avg_salary DESC
LIMIT 7;

-- 8.Correlation-type Logic (SQL Approx)
SELECT 
    experience_years,
    AVG(salary) AS avg_salary
FROM job_data
GROUP BY experience_years;

-- 9.View Creation 
CREATE VIEW salary_summary AS
SELECT 
    job_title,
    AVG(salary) AS avg_salary,
    COUNT(*) AS total_employees
FROM job_data
GROUP BY job_title;

select *from salary_summary;