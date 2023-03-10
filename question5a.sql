SELECT e.`year`, e.GDP FROM economies AS e
WHERE (`YEAR` BETWEEN 2008 AND 2020) 
AND country IN ('Czech Republic')

SELECT 
	t_sallary.`year`, 
	t_sallary.percentige_diff_sallary, 
	t_price.percentige_diff_price,
	t_sallary.percentige_diff_sallary-t_price.percentige_diff_price AS percentage_point_difference
FROM 
	(
	SELECT 
		`YEAR`,
		round(avg(average_salary) / (lag(avg(average_salary)) OVER (ORDER BY `year`)) * 100 -100, 2) AS percentige_diff_sallary
	FROM t_jakub_janoska_project_sql_primary_final AS pp
	GROUP BY `year`
	ORDER BY `year`) AS t_sallary
JOIN 
	(
	SELECT 
		`YEAR`, 
		round(avg(average_price) / (lag(avg(average_price)) OVER (ORDER BY `year`)) * 100- 100 , 2) AS percentige_diff_price
	FROM t_jakub_janoska_project_sql_primary_final AS pp
	GROUP BY `year`
	ORDER BY `year`) AS t_price
	ON
	t_sallary.YEAR = t_price.YEAR

	
	
SELECT 
	cz_gdp.`year` AS `year`,  cz_gdp.gdp_diff_percentige, percentige_diff_salary, percentige_diff_price
FROM 
	(SELECT
	e.`year`,
	e.GDP,
	-- lag(e.GDP) OVER (ORDER BY `year`) AS last_year_gdp,
	-- e.GDP - (lag(e.GDP) OVER (ORDER BY `year`)) AS gdp_diff,
	round(e.GDP / (lag(e.GDP) OVER (ORDER BY `year`)) * 100 -100 ,2)  AS gdp_diff_percentige
	FROM economies AS e
	WHERE
	(`YEAR` BETWEEN 2006 AND 2020)
	AND country IN ('Czech Republic')
	Order BY e.`year`) AS cz_gdp
	JOIN
		(
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
	ON t_salary.YEAR = t_price.YEAR) AS price_and_salary_diff
	ON cz_gdp.`year` = price_and_salary_diff.`year`

	
SELECT
	e.`year`,
	e.GDP,
	-- lag(e.GDP) OVER (ORDER BY `year`) AS last_year_gdp,
	-- e.GDP - (lag(e.GDP) OVER (ORDER BY `year`)) AS gdp_diff,
	round(e.GDP / (lag(e.GDP) OVER (ORDER BY `year`)) * 100 -100 ,2)  AS gdp_diff_percentige
FROM economies AS e
WHERE
	(`YEAR` BETWEEN 2008 AND 2020)
	AND country IN ('Czech Republic')
	Order BY e.`year`