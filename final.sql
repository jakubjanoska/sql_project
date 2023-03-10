 -- summary table nr. one 	
CREATE OR REPLACE TABLE t_cz_payroll_cut		
SELECT 
	cp.value,
	cpu.name AS KC_or_thousand_of_ppl,
	cpib.name AS name_of_industry_branch,
	cp.payroll_year AS `year`,
	concat('Q', cp.payroll_quarter, '-', cp.payroll_year) AS quarter_year
FROM czechia_payroll AS cp 
JOIN czechia_payroll_value_type AS cpvt 
	ON cp.value_type_code = cpvt.code 
JOIN czechia_payroll_unit AS cpu 
	ON cp.unit_code = cpu.code 
JOIN czechia_payroll_calculation AS cpc 
	ON cp.calculation_code = cpc.code 
JOIN czechia_payroll_industry_branch AS cpib 
	ON cp.industry_branch_code = cpib.code
WHERE value IS NOT NULL
 	AND cp.calculation_code = 200
 	AND cp.value_type_code = 5958;

-- summary table nr. two 	
CREATE OR REPLACE TABLE t_cz_price_cut
SELECT
	ROUND(AVG(cp.value),2) AS avg_price,
    cpc.name AS product,
    cpc.price_value,
    cpc.price_unit, 
    year(cp.date_from) AS `year`,
    concat('Q', quarter(cp.date_from), '-' , year(cp.date_from)) AS quarter_year
FROM
    czechia_price AS cp
JOIN czechia_price_category AS cpc 
    ON cp.category_code = cpc.code 
WHERE cp.region_code IS NULL 
GROUP BY cpc.name, YEAR(cp.date_from), quarter(cp.date_from)
ORDER BY cpc.name, cp.date_from;

-- final verzion of primary table
CREATE OR REPLACE TABLE t_jakub_janoska_project_SQL_primary_final
SELECT 
	cpc.quarter_year AS quarter_and_year, 
	cpc.`year` AS `year`, 
	cprl.value AS average_salary, 
	cprl.name_of_industry_branch AS industry, 
	cpc.avg_price AS average_price, 
	cpc.product AS item, 
	cpc.price_value AS amount, 
	cpc.price_unit AS unit 
FROM t_cz_payroll_cut AS cprl 
CROSS JOIN t_cz_price_cut  AS cpc 
WHERE cprl.quarter_year = cpc.quarter_year
ORDER BY cprl.name_of_industry_branch

-- final verzion of secondary table
CREATE OR REPLACE TABLE t_jakub_janoska_project_SQL_secondary_final
SELECT
	c.country, 
	ec.`year`, 
	ec.GDP,
	ec.gini, 
	ec.population
FROM countries AS c 
JOIN economies AS ec
	ON ec.country = c.country 
WHERE (`YEAR` BETWEEN 2006 AND 2020) 
	AND c.continent = 'Europe'
ORDER BY c.country, ec.`year` 


-- 1.question
SELECT 
	cpib.name AS name_of_industry_branch,
	cp.payroll_year,
	round(avg(value),0) AS average_salary_in_CZK,
	round(avg(value) / lag(round(avg(value),0)) OVER (ORDER BY cpib.name, cp.payroll_year, cp.payroll_quarter) *100 - 100 ,4) AS salary_difference
FROM
	czechia_payroll AS cp
JOIN czechia_payroll_industry_branch AS cpib 
	ON cp.industry_branch_code  = cpib.code
JOIN czechia_payroll_calculation AS cpc 
	ON cp.calculation_code = cpc.code 
WHERE cp.calculation_code = 200
	AND cp.value_type_code = 5958
GROUP BY cpib.code, cp.payroll_year
ORDER BY
	cpib.name,
	cp.payroll_year,
	cp.payroll_quarter;


-- 2.question
SELECT 
	quarter_and_year,
	ROUND(AVG(average_salary), 0) AS average_salary,
	average_price,
	item,
	ROUND(AVG(average_salary) / average_price, 0) AS amount_of_items
FROM
	t_jakub_janoska_project_sql_primary_final AS pp
WHERE
		item IN ('Mléko polotučné pasterované', 'Chléb konzumní kmínový')
	AND quarter_and_year IN ('Q1-2006', 'Q4-2018')
GROUP BY
	quarter_and_year,
	item
	
-- 3.question	
SELECT 
	item, 
	round(avg(percentage.yearly_percentage_diff),3) AS percentage_difference
FROM (
	SELECT
		item, 
		avg(average_price) AS yearly_average_price, 
		round(avg(average_price) / (lag(avg(average_price)) OVER (PARTITION BY item ORDER BY `year`)) * 100 - 100, 2) AS yearly_percentage_diff
	FROM
		t_jakub_janoska_project_sql_primary_final AS pp 
	GROUP BY item, `year` 
) AS percentage
GROUP BY item
ORDER BY avg(yearly_percentage_diff)

-- 4.question
SELECT 
	t_salary.`year`, 
	t_salary.percentige_diff_salary, 
	t_price.percentige_diff_price,
	t_salary.percentige_diff_salary-t_price.percentige_diff_price AS percentage_point_difference
FROM 
	(
	SELECT 
		`YEAR`,
		round(avg(average_salary) / (lag(avg(average_salary)) OVER (ORDER BY `year`)) * 100 -100, 2) AS percentige_diff_salary
	FROM t_jakub_janoska_project_sql_primary_final AS pp
	GROUP BY `year`
	ORDER BY `year`) AS t_salary
JOIN 
	(
	SELECT 
		`YEAR`, 
		round(avg(average_price) / (lag(avg(average_price)) OVER (ORDER BY `year`)) * 100- 100 , 2) AS percentige_diff_price
	FROM t_jakub_janoska_project_sql_primary_final AS pp
	GROUP BY `year`
	ORDER BY `year`) AS t_price
	ON
	t_salary.YEAR = t_price.YEAR
WHERE t_salary.percentige_diff_salary-t_price.percentige_diff_price IS NOT NULL;