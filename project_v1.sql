SELECT
	cp.id, 
	cpib.name AS name_of_industry_branch,
	cp.payroll_year,
	cp.payroll_quarter, 
	cp.value,
	cpu.name AS currency 
FROM
	czechia_payroll AS cp
JOIN czechia_payroll_industry_branch AS cpib 
	ON cp.industry_branch_code = cpib.code
JOIN czechia_payroll_unit AS cpu 
	ON cp.unit_code = cpu.code
JOIN czechia_payroll_calculation AS cpc 
	ON cp.calculation_code = cpc.code 
WHERE
		cp.value IS NOT NULL 
	AND cp.calculation_code = 100
	AND cp.value_type_code = 5958
ORDER BY
	cp.industry_branch_code,
	cp.payroll_year,
	cp.payroll_quarter;

/* Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
 * 
 */
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
	*
FROM czechia_payroll AS cp 
JOIN czechia_payroll_industry_branch AS cpib 
	ON cp.industry_branch_code = cpib.code 
WHERE cp.id IN (741381972, 741373878, 741371809)

SELECT *
FROM czechia_payroll AS cp 
LEFT JOIN czechia_payroll_calculation AS cpc 
	ON cp.calculation_code = cpc.code 
LEFT JOIN czechia_payroll_industry_branch AS cpib 
	ON cp.industry_branch_code = cpib.code 
LEFT JOIN czechia_payroll_unit AS cpu 
	ON cp.unit_code = cpu.code 
LEFT JOIN czechia_payroll_value_type AS cpvt 
	ON cp.industry_branch_code = cpvt.code
WHERE cp.id IN (741381972, 741373878); 

SELECT 
	*,
	IF (value)
FROM czechia_payroll AS cp 
JOIN czechia_payroll_industry_branch AS cpib 
	ON cp.industry_branch_code = cpib.code 
WHERE cp.id IN (741373878, 741373879, 741373880, 741373881) AND

