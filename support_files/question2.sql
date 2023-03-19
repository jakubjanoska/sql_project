SELECT
    cp.id,
    ROUND(AVG(cp.value),2) AS avg_price,
    cpc.name,
    date_format(cp.date_from, '%m.%Y') AS price_measured_from,
    -- date_format(cp.date_to, '%M %Y') AS price_measured_to,
    cpc.price_value,
    cpc.price_unit,
    cr.name 
FROM
    czechia_price AS cp
JOIN czechia_price_category AS cpc 
    ON cp.category_code = cpc.code 
JOIN czechia_region AS cr  
    ON cp.region_code = cr.code 
WHERE (cp.category_code IN (111301, 114201) 
    AND 
        (cp.date_from = (
        SELECT MIN(date_from)  
        FROM czechia_price) 
        OR
        cp.date_from = (
        SELECT MAX(date_from)  
        FROM czechia_price 
        )))
GROUP BY cpc.name, price_measured_from
ORDER BY cpc.name;

SELECT 
quarter_and_year,
ROUND(AVG(average_salary),0), 
average_price, 
item, 
amount, 
unit 
FROM t_jakub_janoska_project_sql_primary_final AS pp
WHERE item IN ('Mléko polotučné pasterované', 'Chléb konzumní kmínový')
	AND quarter_and_year IN ('Q1-2006', 'Q4-2018')
GROUP BY quarter_and_year, item 

SELECT 
*
FROM t_jakub_janoska_project_sql_primary_final AS pp
WHERE item IN ('Mléko polotučné pasterované', 'Chléb konzumní kmínový')
	AND quarter_and_year IN ('Q1-2006', 'Q4-2018')
-- GROUP BY quarter_and_year, item 
	
SELECT 
`year`, 
item, 
avg(pp.average_price)
FROM t_jakub_janoska_project_sql_primary_final AS pp
GROUP BY pp.`year`, pp.item 
ORDER BY item, `year`  

SELECT * FROM t_jakub_janoska_project_sql_primary_final AS tjjpspf 


SELECT
	cp.value, 
	cpc.name,
	year(cp.date_from) AS `Year`,
	-- cp.region_code,
	avg(value) AS avg_price
FROM 
	czechia_price AS cp 
JOIN czechia_price_category AS cpc 
	ON cp.category_code = cpc.code
WHERE cp.region_code IS NOT NULL 
GROUP BY cpc.name, year(cp.date_from)

SELECT 
	*, 
	cpc.name,
	cr.name
FROM czechia_price AS cp 
JOIN czechia_price_category AS cpc 
	ON cp.category_code = cpc.code
LEFT JOIN czechia_region AS cr  
 	ON cp.region_code = cr.code 
WHERE cpc.name = 'Banány žluté' AND YEAR(cp.date_from) = 2016 



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
WHERE cp.region_code IS  NULL 
GROUP BY cpc.name, YEAR(cp.date_from), quarter(cp.date_from)
ORDER BY cpc.name, cp.date_from;

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