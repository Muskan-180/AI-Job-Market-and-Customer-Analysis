

-- 1. Average Salary by Job Title
-- Benchmarks the average compensation across different AI roles.
SELECT 
    job_title,
    COUNT(job_id) AS total_postings,
    ROUND(AVG(salary_usd), 2) AS average_salary_usd
FROM 
    ai_job_market_trends
GROUP BY 
    job_title
ORDER BY 
    average_salary_usd DESC;

-- 2. Remote Work & Global Mobility (Cross-Border Sourcing)
-- Identifies the volume and average salary of cross-border hires (where company location differs from employee residence).
SELECT 
    COUNT(job_id) AS cross_border_postings,
    ROUND(AVG(salary_usd), 2) AS avg_cross_border_salary
FROM 
    ai_job_market_trends
WHERE 
    company_location <> employee_residence;

-- 3. Top 10 In-Demand AI Skills
-- Flattens the comma-separated required_skills column to count the frequency of each skill.
WITH unnested_skills AS (
    SELECT TRIM(LOWER(UNNEST(string_to_array(required_skills, ',')))) AS skill
    FROM ai_job_market_trends
)
SELECT 
    skill,
    COUNT(*) AS demand_frequency
FROM 
    unnested_skills
GROUP BY 
    skill
ORDER BY 
    demand_frequency DESC
LIMIT 10;

-- 4. Education & Experience Alignment
-- Correlates minimum education requirements with the average years of experience demanded.
SELECT 
    education_required,
    ROUND(AVG(years_experience), 1) AS avg_years_experience
FROM 
    ai_job_market_trends
GROUP BY 
    education_required
ORDER BY 
    avg_years_experience ASC;

-- 5. Hiring Seasonality & Forecasting
-- Detects monthly hiring cycles based on posting dates.
SELECT 
    EXTRACT(MONTH FROM posting_date) AS posting_month,
    TO_CHAR(posting_date, 'Month') AS month_name,
    COUNT(job_id) AS total_postings
FROM 
    ai_job_market_trends
GROUP BY 
    EXTRACT(MONTH FROM posting_date),
    TO_CHAR(posting_date, 'Month')
ORDER BY 
    posting_month ASC;

-- 6. Industry Salary Comparison
-- Compares average financial investment in AI talent across various industry sectors.
SELECT 
    industry,
    COUNT(job_id) AS hiring_volume,
    ROUND(AVG(salary_usd), 2) AS avg_industry_salary
FROM 
    ai_job_market_trends
GROUP BY 
    industry
ORDER BY 
    avg_industry_salary DESC;

-- 7. Top 10 Hiring Companies
-- Ranks organizations by total volume of AI job postings.
SELECT 
    company_name,
    COUNT(job_id) AS total_postings
FROM 
    ai_job_market_trends
GROUP BY 
    company_name
ORDER BY 
    total_postings DESC
LIMIT 10;

-- 8. Job Description Length vs. Benefits Score Correlation
-- Assesses whether longer job descriptions correlate with higher benefit scores.
SELECT 
    CORR(job_description_length, benefits_score) AS description_benefits_correlation
FROM 
    ai_job_market_trends;