-- avg sallary in industry branch, quartal and year  
SELECT 
	cp.id,
	cp.value,
	-- cp.value_type_code AS 316workers_or_5958mzda,
	cpvt.name,
	-- cp.unit_code AS 80403people_or_200kc,
	cpu.name AS KC_or_thousand_of_ppl,
	-- cp.calculation_code AS sto_dvesto,
	cpc.name AS typ_prepoctu,
	-- cp.industry_branch_code, 
	cpib.name AS name_of_industry_branch,
	cp.payroll_year,
	cp.payroll_quarter 
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
	-- AND cp.value_type_code = 5958
	-- AND cp.unit_code = 200
;

-- returns avg prices of item in quartal and region 
SELECT
    cp.id,
	-- cp.value,
	ROUND(AVG(cp.value),2) AS avg_price,
    cpc.name AS product,
    -- date_format(cp.date_from, '%d.%m.%Y') AS price_measured_from,
	year(cp.date_from) AS `year`,
	-- date_format(cp.date_to, '%m.%Y') AS price_measured_to,
    quarter(cp.date_from) AS quartal,
    -- quarter(cp.date_to) AS quartal_based_on_to, 
    -- cpc.price_value,
    -- cpc.price_unit,
    cr.name AS region_name
FROM
    czechia_price AS cp
JOIN czechia_price_category AS cpc 
    ON cp.category_code = cpc.code 
LEFT JOIN czechia_region AS cr  
    ON cp.region_code = cr.code 
WHERE cp.region_code IS NULL
GROUP BY cpc.name, YEAR(cp.date_from), quarter(cp.date_from), cr.name  
-- ORDER BY cpc.name, cp.date_from;

SELECT  cp.value, cpc.name, cp.region_code, cr.name, cp.date_from  FROM czechia_price AS cp 
LEFT JOIN czechia_price_category AS cpc 
    ON cp.category_code = cpc.code 
LEFT JOIN czechia_region AS cr  
    ON cp.region_code = cr.code 
ORDER BY category_code, date_from, region_code 

CREATE OR REPLACE TABLE t_test
	SELECT 
		t.city, t.job, t.`size`, tt.food, tt.animal  
	FROM t_22 AS t 
	CROSS JOIN t_table_21 AS tt 
	WHERE 
		t.`size` IS NOT NULL 
		
/*
 * summary table nr. one 
 */		
-- CREATE OR REPLACE TABLE t_cz_payroll_cut		
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

-- CREATE OR REPLACE TABLE t_cz_price_cut
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

SELECT * 
FROM t_cz_payroll_cut AS cprl 
CROSS JOIN t_cz_price_cut  AS cpc 
WHERE cprl.quarter_year = cpc.quarter_year
ORDER BY cprl.name_of_industry_branch

CREATE OR REPLACE TABLE t_jakub_janoska_project_SQL_primary_final
SELECT 
	cpc.quarter_year, 
	cprl.value, 
	cprl.name_of_industry_branch, 
	cpc.avg_price, 
	cpc.product, 
	cpc.price_value, 
	cpc.price_unit 
FROM t_cz_payroll_cut AS cprl 
CROSS JOIN t_cz_price_cut  AS cpc 
WHERE cprl.quarter_year = cpc.quarter_year
ORDER BY cprl.name_of_industry_branch

/*
 * End of table1
 */		
		
SELECT 
*,
concat(tcpc.quarter, '.', tcpc.`year`) AS quarter_year
FROM t_cz_payroll_cut AS tcpc 


SELECT 
	cpib.name AS name_of_industry_branch,
	cp.payroll_year,
	round(avg(value),0) AS average_salary_in_CZK
FROM
	czechia_payroll AS cp
JOIN czechia_payroll_industry_branch AS cpib 
	ON cp.industry_branch_code = cpib.code
JOIN czechia_payroll_calculation AS cpc 
	ON cp.calculation_code = cpc.code 
WHERE
		cp.value IS NOT NULL 
	AND cp.calculation_code = 100
	AND cp.value_type_code = 5958
GROUP BY cpib.code, cp.payroll_year
ORDER BY
	cp.industry_branch_code,
	cp.payroll_year,
	cp.payroll_quarter;

SELECT
	*,
	date_format(cp.date_from, '%Y') AS `year`
FROM
	czechia_price AS cp;


SELECT  * FROM czechia_payroll AS CPayroll
UNION ALL
SELECT * FROM  czechia_price AS Cprice 


