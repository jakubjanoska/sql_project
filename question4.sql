SELECT 
	`YEAR`, 
	avg(average_salary) AS avg_yearly_salary,
 	-- lag(avg(average_salary)) OVER (ORDER BY `year`) AS last_year_avg,
 	-- avg(average_salary) - (lag(avg(average_salary)) OVER (ORDER BY `year`)) AS actual_diff,
 	round(avg(average_salary) / (lag(avg(average_salary)) OVER (ORDER BY `year`)) * 100 -100 ,2) AS percentige_diff_sallary
FROM t_jakub_janoska_project_sql_primary_final AS pp
GROUP BY `year`
ORDER BY `year`

SELECT 
	`YEAR`, 
	avg(average_price) AS avg_yearly_price,
 	-- lag(avg(average_price)) OVER (ORDER BY `year`) AS last_year_avg,
 	-- avg(average_price) - (lag(avg(average_price)) OVER (ORDER BY `year`)) AS actual_diff,
 	round(avg(average_price) / (lag(avg(average_price)) OVER (ORDER BY `year`)) * 100 -100 ,2) AS percentige_diff_price
FROM t_jakub_janoska_project_sql_primary_final AS pp
GROUP BY `year`
ORDER BY `year`

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
	t_sallary.YEAR = t_price.YEAR;
-- WHERE t_sallary.percentige_diff_sallary-t_price.percentige_diff_price IS NOT NULL;
	