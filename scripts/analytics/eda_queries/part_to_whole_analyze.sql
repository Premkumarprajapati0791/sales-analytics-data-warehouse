 -- Part to whole analyze
 -- which category contribute to most in overall

SELECT 
    d.category,
    CONCAT(ROUND(SUM(f.quantity * f.price) / (SELECT 
                            SUM(quantity * price)
                        FROM
                            gold.fact_sales) * 100,
                    2),
            '%') AS percentage
FROM
    gold.fact_sales f
        JOIN
    gold.dim_products d ON d.product_key = f.product_key
WHERE
    d.category IS NOT NULL
GROUP BY d.category;