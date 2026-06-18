-- =====================================================
-- Financial Planning & Analysis Dashboard
-- NovaTech Solutions
-- SQL Analysis Queries
-- =====================================================


-- 1. Total Revenue Actual
-- Business Question:
-- How much revenue did the company generate?

SELECT
    SUM(amount) AS total_revenue
FROM fact_financials
WHERE account_id = 1
AND scenario = 'Actual';



-- 2. Revenue Actual vs Budget
-- Business Question:
-- Are we achieving the revenue plan?

SELECT
    date,
    scenario,
    SUM(amount) AS revenue
FROM fact_financials
WHERE account_id = 1
GROUP BY
    date,
    scenario
ORDER BY date;



-- 3. Monthly Variance Analysis
-- Business Question:
-- Where are we above or below budget?

SELECT
    date,

    SUM(
        CASE 
            WHEN scenario = 'Actual'
            THEN amount
            ELSE 0
        END
    ) AS actual_revenue,

    SUM(
        CASE 
            WHEN scenario = 'Budget'
            THEN amount
            ELSE 0
        END
    ) AS budget_revenue,

    SUM(
        CASE 
            WHEN scenario = 'Actual'
            THEN amount
            ELSE 0
        END
    )
    -
    SUM(
        CASE 
            WHEN scenario = 'Budget'
            THEN amount
            ELSE 0
        END
    ) AS variance

FROM fact_financials

WHERE account_id = 1

GROUP BY date
ORDER BY date;



-- 4. Expenses by Department
-- Business Question:
-- Which areas drive costs?

SELECT
    d.department,
    SUM(f.amount) AS total_expenses

FROM fact_financials f

INNER JOIN dim_department d
ON f.department_id = d.department_id

WHERE f.scenario = 'Actual'
AND f.account_id <> 1

GROUP BY d.department

ORDER BY total_expenses DESC;



-- 5. Profit Calculation
-- Business Question:
-- What is profitability?

SELECT

    date,

    SUM(
        CASE 
        WHEN account_id = 1
        THEN amount
        ELSE 0
        END
    )

    -

    SUM(
        CASE 
        WHEN account_id <> 1
        THEN amount
        ELSE 0
        END
    )

    AS profit

FROM fact_financials

WHERE scenario = 'Actual'

GROUP BY date

ORDER BY date;
