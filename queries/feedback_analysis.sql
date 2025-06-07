
-- 📞 Query 3: Average operator feedback per manager (phone surveys only)
SELECT 
    m.name AS manager_name,
    ROUND(AVG(cf.operator_rating), 2) AS avg_operator_score
FROM 
    Call_Feedback cf
JOIN 
    Managers m ON cf.manager_id = m.manager_id
GROUP BY 
    m.manager_id
ORDER BY 
    avg_operator_score DESC;
