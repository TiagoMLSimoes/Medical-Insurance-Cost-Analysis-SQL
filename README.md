Medical Insurance Cost Analysis (SQL)

📊 Project Overview
This project performs an exploratory data analysis (EDA) on a health insurance dataset to identify the primary factors driving medical costs. Using PostgreSQL, I analyzed demographic data, lifestyle habits (smoking), and BMI to extract actionable business insights.

🚀 Key Insights

Smoking Impact: Smokers face significantly higher medical charges compared to non-smokers, regardless of age.

The Obesity Trap: The combination of smoking and a BMI over 30 results in the highest average charges in the entire dataset.

Regional Trends: Charges are relatively consistent across regions, though the Southeast shows a higher density of high-cost patients.

🛠️ Technologies Used

Database: PostgreSQL

SQL Client: Postbird / VS Code

Concepts: Data Cleaning, Aggregations, Case Logic, Window Functions (RANK), and Views.

📁 Repository Structure

insurance.csv: Raw dataset containing 1,338 records.

insurance_analysis.sql: Full SQL script with data cleaning and analysis queries.

screenshots/: Folder containing query results and visualizations.

🔍 Featured Queries
1. Risk Analysis (Smoker vs. BMI)

This query segments patients into weight categories and compares average charges based on smoking status.

```
SELECT 
    smoker, 
    CASE 
        WHEN bmi < 25 THEN 'Normal Weight'
        WHEN bmi BETWEEN 25 AND 29.9 THEN 'Overweight'
        ELSE 'Obese'
    END AS weight_category,
    ROUND(AVG(charges), 2) AS avg_charges
FROM insurance
GROUP BY 1, 2
ORDER BY 3 DESC;
```

Result Insight: Obese smokers pay significantly more than any other group.

2. Regional Rankings

Using Window Functions to identify the top 5 highest-cost patients per region.

```
SELECT region, age, charges,
       RANK() OVER (PARTITION BY region ORDER BY charges DESC) as cost_rank
FROM insurance
WHERE cost_rank <= 5;
```

📈 How to Run

Create a PostgreSQL database.

Run the CREATE TABLE command found in insurance_analysis.sql.

Import the insurance.csv file.

Execute the analysis queries to see the results.

✉️ Contact

Name: Tiago Simões

LinkedIn: [www.linkedin.com/in/tiago-simoes-data04]

Email: t.simoes.pessoal@gmail.com
