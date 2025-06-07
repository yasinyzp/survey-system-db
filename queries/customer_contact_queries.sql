
-- 📧 Query 2: Customers who were contacted more than 3 times
SELECT 
    c.name, c.surname, c.contact_number,
    COUNT(n.notification_id) AS total_contacts
FROM 
    Customers c
JOIN 
    Notifications n ON c.customer_id = n.customer_id
GROUP BY 
    c.customer_id
HAVING 
    COUNT(n.notification_id) > 3
ORDER BY 
    total_contacts DESC;
