
-- 📊 Query 1: Top-rated products (average feedback score)
SELECT 
    p.name AS product_name,
    ROUND(AVG(sr.rating), 2) AS avg_rating
FROM 
    Survey_Results sr
JOIN 
    Products p ON sr.product_id = p.product_id
GROUP BY 
    p.name
ORDER BY 
    avg_rating DESC
LIMIT 10;
