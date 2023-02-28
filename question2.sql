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