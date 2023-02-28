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
JOIN czechia_region AS cr  
    ON cp.region_code = cr.code 
GROUP BY cpc.name, YEAR(cp.date_from), quarter(cp.date_from), cr.name  
ORDER BY cpc.name, cp.date_from;





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


