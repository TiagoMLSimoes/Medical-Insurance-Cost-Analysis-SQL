{\rtf1\ansi\ansicpg1252\cocoartf2867
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 /*******************************************************************************\
PROJECT: Health Insurance Cost Analysis\
OBJECTIVE: Identify the key drivers of healthcare charges using SQL.\
FEATURES: Data Cleaning, Statistical Aggregations, Window Functions, and Views.\
*******************************************************************************/\
\
-- STEP 1: DATABASE SETUP\
-- Creating the table with appropriate data types.\
\
DROP TABLE IF EXISTS insurance; -- Clean start if re-running\
\
CREATE TABLE insurance (\
    age INT,\
    sex VARCHAR(10),\
    bmi DECIMAL(10, 2),\
    children INT,\
    smoker VARCHAR(3),\
    region VARCHAR(20),\
    charges DECIMAL(15, 5)\
);\
\
-- Note: Import the CSV using Postbird's import tool or the COPY command.\
\
\
-- STEP 2: DATA QUALITY CHECK (Essential for Portfolio)\
-- Checking for nulls or inconsistent data.\
\
SELECT \
    COUNT(*) AS total_rows,\
    COUNT(charges) AS non_null_charges,\
    MIN(age) AS min_age,\
    MAX(age) AS max_age\
FROM insurance;\
\
\
-- STEP 3: LIFESTYLE RISK ANALYSIS\
-- Comparing charges between smokers and non-smokers across BMI categories.\
-- Insight: Does obesity only affect costs if the person is a smoker?\
\
SELECT \
    smoker, \
    CASE \
        WHEN bmi < 25 THEN 'Under/Normal Weight'\
        WHEN bmi BETWEEN 25 AND 29.9 THEN 'Overweight'\
        ELSE 'Obese'\
    END AS weight_category,\
    ROUND(AVG(charges), 2) AS avg_charges,\
    COUNT(*) AS patient_count\
FROM insurance\
GROUP BY 1, 2\
ORDER BY 1, 3 DESC;\
\
\
-- STEP 4: AGE DEMOGRAPHICS & CORRELATION\
-- Analyzing how costs evolve by age decade.\
\
SELECT \
    FLOOR(age / 10) * 10 AS age_decade,\
    smoker,\
    ROUND(AVG(charges), 2) AS avg_charges\
FROM insurance\
GROUP BY 1, 2\
ORDER BY 1, 2;\
\
\
-- STEP 5: REGIONAL BENCHMARKING (Advanced Window Functions)\
-- Identifying the most expensive patients in each region.\
\
SELECT * FROM (\
    SELECT \
        region, \
        age, \
        sex,\
        charges,\
        RANK() OVER (PARTITION BY region ORDER BY charges DESC) as cost_rank\
    FROM insurance\
) AS ranked_patients\
WHERE cost_rank <= 5;\
\
\
-- STEP 6: BUSINESS VIEW FOR BI TOOLS\
-- Creating a clean view to be used in Power BI or Tableau dashboards.\
CREATE OR REPLACE VIEW v_insurance_dashboard AS\
SELECT \
    region,\
    sex,\
    smoker,\
    COUNT(*) AS total_patients,\
    ROUND(AVG(bmi), 2) AS avg_bmi,\
    ROUND(AVG(charges), 2) AS avg_charges,\
    ROUND(SUM(charges), 2) AS total_revenue\
FROM insurance\
GROUP BY 1, 2, 3;\
\
-- Final Verification:\
SELECT * FROM v_insurance_dashboard;}