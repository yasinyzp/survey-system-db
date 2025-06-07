CREATE TABLE Companies (
    company_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    activity_license_code VARCHAR(15) UNIQUE NOT NULL
);

CREATE TABLE Managers (
    manager_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_number VARCHAR(15) NOT NULL,
    national_code VARCHAR(10) UNIQUE NOT NULL,
    company_id INT REFERENCES Companies(company_id) ON DELETE CASCADE
);

CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    contact_number VARCHAR(15) NOT NULL,
    email VARCHAR(100) NOT NULL
);

CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    unique_code VARCHAR(15) UNIQUE NOT NULL
);

CREATE TABLE Invoices (
    invoice_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id) ON DELETE CASCADE,
    manager_id INT REFERENCES Managers(manager_id) ON DELETE SET NULL
);

CREATE TABLE Invoice_Items (
    invoice_item_id SERIAL PRIMARY KEY,
    invoice_id INT REFERENCES Invoices(invoice_id) ON DELETE CASCADE,
    product_id INT REFERENCES Products(product_id) ON DELETE CASCADE
);

CREATE TABLE Surveys (
    survey_id SERIAL PRIMARY KEY,
    manager_id INT REFERENCES Managers(manager_id) ON DELETE CASCADE,
    method VARCHAR(10) CHECK (method IN ('email', 'sms', 'phone')) NOT NULL,
    message TEXT NOT NULL
);

CREATE TABLE Survey_Responses (
    response_id SERIAL PRIMARY KEY,
    survey_id INT REFERENCES Surveys(survey_id) ON DELETE CASCADE,
    customer_id INT REFERENCES Customers(customer_id) ON DELETE CASCADE,
    product_id INT REFERENCES Products(product_id) ON DELETE CASCADE,
    rating INT CHECK (rating BETWEEN 1 AND 5) NOT NULL
);

CREATE TABLE Operator_Ratings (
    rating_id SERIAL PRIMARY KEY,
    survey_id INT REFERENCES Surveys(survey_id) ON DELETE CASCADE,
    customer_id INT REFERENCES Customers(customer_id) ON DELETE CASCADE,
    operator_rating INT CHECK (operator_rating BETWEEN 1 AND 5) NOT NULL
);

CREATE TABLE Notifications (
    notification_id SERIAL PRIMARY KEY,
    manager_id INT REFERENCES Managers(manager_id) ON DELETE CASCADE,
    customer_id INT REFERENCES Customers(customer_id) ON DELETE CASCADE,
    message TEXT NOT NULL,
    method VARCHAR(10) CHECK (method IN ('email', 'sms')) NOT NULL
);

-- -------------------------------------------------------------------
-- Input datas

INSERT INTO Companies (name, activity_license_code) VALUES
('TechCorp', 'LIC12345'),
('MediHealth', 'LIC67890'),
('EduWorld', 'LIC54321');

INSERT INTO Managers (name, contact_number, national_code, company_id) VALUES
('Alice Johnson', '123-456-7890', '1001', 1),
('Bob Smith', '123-555-7891', '1002', 1),
('Clara Lee', '123-456-5555', '1003', 2),
('David Kim', '123-456-6666', '1004', 2),
('Eva Green', '123-555-7777', '1005', 3),
('Frank White', '123-456-8888', '1006', 3);

-- Insert data into Customers
INSERT INTO Customers (name, surname, contact_number, email) VALUES
('John', 'Doe', '555-1234', 'john.doe@example.com'),
('Jane', 'Doe', '555-5678', 'jane.doe@example.com'),
('Mike', 'Ross', '555-8765', 'mike.ross@example.com'),
('Rachel', 'Green', '555-4321', 'rachel.green@example.com'),
('Monica', 'Geller', '555-2345', 'monica.geller@example.com'),
('Chandler', 'Bing', '555-6789', 'chandler.bing@example.com'),
('Ross', 'Geller', '555-9876', 'ross.geller@example.com'),
('Phoebe', 'Buffay', '555-6543', 'phoebe.buffay@example.com'),
('Joey', 'Tribbiani', '555-3456', 'joey.tribbiani@example.com'),
('Rachel', 'Adams', '555-4567', 'rachel.adams@example.com');

INSERT INTO Products (name, unique_code) VALUES
('Laptop', 'PROD001'),
('Smartphone', 'PROD002'),
('Tablet', 'PROD003'),
('Headphones', 'PROD004'),
('Fitness Tracker', 'PROD005');

INSERT INTO Invoices (customer_id, manager_id) VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 3),
(5, 4),
(6, 5);

INSERT INTO Invoice_Items (invoice_id, product_id) VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 4),
(4, 5),
(5, 1),
(6, 2);

INSERT INTO Surveys (manager_id, method, message) VALUES
(1, 'email', 'How do you rate our service?'),
(2, 'sms', 'Please rate our product quality.'),
(3, 'phone', 'Give us feedback on our operator service.');

INSERT INTO Survey_Responses (survey_id, customer_id, product_id, rating) VALUES
(1, 1, 1, 5),
(1, 2, 2, 4),
(2, 3, 3, 3),
(2, 4, 4, 2),
(3, 5, 5, 1);

INSERT INTO Operator_Ratings (survey_id, customer_id, operator_rating) VALUES
(3, 1, 5),
(3, 2, 4),
(3, 3, 3);

INSERT INTO Notifications (manager_id, customer_id, message, method) VALUES
(1, 1, 'Check out our latest product!', 'email'),
(2, 2, 'Special discounts available!', 'sms'),
(3, 3, 'New arrivals in stock.', 'email'),
(4, 4, 'Exclusive offers for you.', 'sms');

-- ---------------------------------------------------------------------
-- Queries

-- 1. name and activity license code for all companies.
SELECT name, activity_license_code 
FROM Companies;

-- 2. names of managers and their companies.
SELECT Managers.name AS manager_name, Companies.name AS company_name
FROM Managers
JOIN Companies ON Managers.company_id = Companies.company_id;

-- 3. customers who made invoices and contact numbers.
SELECT DISTINCT Customers.name, Customers.surname, Customers.contact_number
FROM Customers
JOIN Invoices ON Customers.customer_id = Invoices.customer_id;

-- 4. List products included in invoices with their unique codes.
SELECT DISTINCT Products.name, Products.unique_code
FROM Products
JOIN Invoice_Items ON Products.product_id = Invoice_Items.product_id;

-- 5. Show invoices and the manager responsible for each.
SELECT Invoices.invoice_id, Managers.name AS manager_name
FROM Invoices
JOIN Managers ON Invoices.manager_id = Managers.manager_id;

-- 6. Count how many surveys each manager has conducted.
SELECT Managers.name, COUNT(Surveys.survey_id) AS total_surveys
FROM Managers
LEFT JOIN Surveys ON Managers.manager_id = Surveys.manager_id
GROUP BY Managers.name;

-- 7. customer names and their ratings from surveys.
SELECT Customers.name, Customers.surname, Survey_Responses.rating
FROM Customers
JOIN Survey_Responses ON Customers.customer_id = Survey_Responses.customer_id;

-- 8. notifications sent, how they were sent, and the customer names.
SELECT Notifications.message, Notifications.method, Customers.name AS customer_name
FROM Notifications
JOIN Customers ON Notifications.customer_id = Customers.customer_id;

-- 9. the average feedback rating for each product.
SELECT Products.name, AVG(Survey_Responses.rating) AS average_rating
FROM Products
JOIN Survey_Responses ON Products.product_id = Survey_Responses.product_id
GROUP BY Products.name;

-- 10. show customers who rated the operator and their ratings.
SELECT Customers.name, Customers.surname, Operator_Ratings.operator_rating
FROM Customers
JOIN Operator_Ratings ON Customers.customer_id = Operator_Ratings.customer_id;

-- 11. products that are not in any invoice.
SELECT Products.name, Products.unique_code
FROM Products
LEFT JOIN Invoice_Items ON Products.product_id = Invoice_Items.product_id
WHERE Invoice_Items.product_id IS NULL;

-- 12. Find managers who haven’t conducted any surveys.
SELECT Managers.name
FROM Managers
LEFT JOIN Surveys ON Managers.manager_id = Surveys.manager_id
WHERE Surveys.survey_id IS NULL;

-- 13. Show invoices and how many items are in each.
SELECT Invoices.invoice_id, COUNT(Invoice_Items.invoice_item_id) AS total_items
FROM Invoices
LEFT JOIN Invoice_Items ON Invoices.invoice_id = Invoice_Items.invoice_id
GROUP BY Invoices.invoice_id;

-- 14. Find companies with managers who haven’t conducted any surveys.
SELECT Companies.name
FROM Companies
JOIN Managers ON Companies.company_id = Managers.company_id
LEFT JOIN Surveys ON Managers.manager_id = Surveys.manager_id
WHERE Surveys.survey_id IS NULL;

-- 15. Count how many invoices each company is responsible for.
SELECT Companies.name AS company_name, COUNT(Invoices.invoice_id) AS total_invoices
FROM Companies
JOIN Managers ON Companies.company_id = Managers.company_id
JOIN Invoices ON Managers.manager_id = Invoices.manager_id
GROUP BY Companies.name;

-- ------------------------------------------------------------------

-- Views and procedures

-- 1. View to show a list of all managers and their company names.
CREATE VIEW manager_companies AS
SELECT Managers.name AS manager_name, Companies.name AS company_name
FROM Managers
JOIN Companies ON Managers.company_id = Companies.company_id;

-- 2. View to show customer names and their total number of invoices.
CREATE VIEW customer_invoices_count AS
SELECT Customers.name AS customer_name, COUNT(Invoices.invoice_id) AS total_invoices
FROM Customers
LEFT JOIN Invoices ON Customers.customer_id = Invoices.customer_id
GROUP BY Customers.name;

-- 3. View to display product names and their average rating from surveys.
CREATE VIEW product_average_rating AS
SELECT Products.name AS product_name, AVG(Survey_Responses.rating) AS avg_rating
FROM Products
JOIN Survey_Responses ON Products.product_id = Survey_Responses.product_id
GROUP BY Products.name;

-- 4. survey details including the manager, survey method, and message.
CREATE VIEW survey_details AS
SELECT Managers.name AS manager_name, Surveys.method, Surveys.message
FROM Surveys
JOIN Managers ON Surveys.manager_id = Managers.manager_id;

-- 5. View to list customers who have not given any survey responses.
CREATE VIEW customers_no_survey_response AS
SELECT Customers.name
FROM Customers
LEFT JOIN Survey_Responses ON Customers.customer_id = Survey_Responses.customer_id
WHERE Survey_Responses.response_id IS NULL;

-- 6. View to list all products and their corresponding invoice counts.
CREATE VIEW product_invoice_count AS
SELECT Products.name AS product_name, COUNT(Invoice_Items.invoice_item_id) AS invoice_count
FROM Products
LEFT JOIN Invoice_Items ON Products.product_id = Invoice_Items.product_id
GROUP BY Products.name;

-- 7. View to show the customer names who received notifications, along with message method.
CREATE VIEW customer_notifications AS
SELECT Customers.name AS customer_name, Notifications.method, Notifications.message
FROM Notifications
JOIN Customers ON Notifications.customer_id = Customers.customer_id;

-- 8. View to show managers who have conducted surveys, and how many surveys they conducted.
CREATE VIEW manager_survey_count AS
SELECT Managers.name AS manager_name, COUNT(Surveys.survey_id) AS total_surveys
FROM Managers
JOIN Surveys ON Managers.manager_id = Surveys.manager_id
GROUP BY Managers.name;

-- 9. View to list all the invoices with the product names they include.
CREATE VIEW invoice_product_list AS
SELECT Invoices.invoice_id, Products.name AS product_name
FROM Invoices
JOIN Invoice_Items ON Invoices.invoice_id = Invoice_Items.invoice_id
JOIN Products ON Invoice_Items.product_id = Products.product_id;

-- 10. View to display the total number of operator ratings for each customer.
CREATE VIEW customer_operator_ratings AS
SELECT Customers.name AS customer_name, COUNT(Operator_Ratings.rating_id) AS total_operator_ratings
FROM Customers
LEFT JOIN Operator_Ratings ON Customers.customer_id = Operator_Ratings.customer_id
GROUP BY Customers.name;

-- ---------------------
-- And procedures

-- 1. Procedure to insert a new customer into the Customers table.
CREATE OR REPLACE PROCEDURE insert_customer(p_name VARCHAR, p_surname VARCHAR, p_contact_number VARCHAR, p_email VARCHAR)
AS $$
BEGIN
    INSERT INTO Customers(name, surname, contact_number, email)
    VALUES (p_name, p_surname, p_contact_number, p_email);
END;
$$ LANGUAGE plpgsql;

-- 2. Procedure to update the contact number of a customer.
CREATE OR REPLACE PROCEDURE update_customer_contact(p_customer_id INT, p_new_contact_number VARCHAR)
AS $$
BEGIN
    UPDATE Customers
    SET contact_number = p_new_contact_number
    WHERE customer_id = p_customer_id;
END;
$$ LANGUAGE plpgsql;

-- 3. Procedure to delete a customer by their ID.
CREATE OR REPLACE PROCEDURE delete_customer(p_customer_id INT)
AS $$
BEGIN
    DELETE FROM Customers WHERE customer_id = p_customer_id;
END;
$$ LANGUAGE plpgsql;

-- 4. Procedure to add a new invoice for a customer.
CREATE OR REPLACE PROCEDURE insert_invoice(p_customer_id INT, p_manager_id INT)
AS $$
BEGIN
    INSERT INTO Invoices(customer_id, manager_id)
    VALUES (p_customer_id, p_manager_id);
END;
$$ LANGUAGE plpgsql;

-- 5. Procedure to insert a new product into the Products table.
CREATE OR REPLACE PROCEDURE insert_product(p_name VARCHAR, p_unique_code VARCHAR)
AS $$
BEGIN
    INSERT INTO Products(name, unique_code)
    VALUES (p_name, p_unique_code);
END;
$$ LANGUAGE plpgsql;

-- 6. Procedure to assign a product to an invoice.
CREATE OR REPLACE PROCEDURE add_product_to_invoice(p_invoice_id INT, p_product_id INT)
AS $$
BEGIN
    INSERT INTO Invoice_Items(invoice_id, product_id)
    VALUES (p_invoice_id, p_product_id);
END;
$$ LANGUAGE plpgsql;

-- 7. Procedure to update the rating for a survey response.
CREATE OR REPLACE PROCEDURE update_survey_rating(p_response_id INT, p_new_rating INT)
AS $$
BEGIN
    UPDATE Survey_Responses
    SET rating = p_new_rating
    WHERE response_id = p_response_id;
END;
$$ LANGUAGE plpgsql;

-- 8. Procedure to send a notification to a customer.
CREATE OR REPLACE PROCEDURE send_notification(p_manager_id INT, p_customer_id INT, p_message TEXT, p_method VARCHAR)
AS $$
BEGIN
    INSERT INTO Notifications(manager_id, customer_id, message, method)
    VALUES (p_manager_id, p_customer_id, p_message, p_method);
END;
$$ LANGUAGE plpgsql;

-- 9. Procedure to get the total number of invoices for a customer.
CREATE OR REPLACE PROCEDURE get_customer_invoices_count(p_customer_id INT, OUT total_invoices INT)
AS $$
BEGIN
    SELECT COUNT(invoice_id) INTO total_invoices
    FROM Invoices
    WHERE customer_id = p_customer_id;
END;
$$ LANGUAGE plpgsql;

-- 10. Procedure to calculate the average operator rating for a customer.
CREATE OR REPLACE PROCEDURE get_average_operator_rating(p_customer_id INT, OUT avg_rating FLOAT)
AS $$
BEGIN
    SELECT AVG(operator_rating) INTO avg_rating
    FROM Operator_Ratings
    WHERE customer_id = p_customer_id;
END;
$$ LANGUAGE plpgsql;

-- 1. Function to get the total number of invoices for a company
CREATE OR REPLACE FUNCTION get_company_invoice_count(p_company_id INT)
RETURNS INT AS $$
DECLARE
    total_invoices INT;
BEGIN
    SELECT COUNT(*) INTO total_invoices
    FROM Invoices
    JOIN Managers ON Invoices.manager_id = Managers.manager_id
    WHERE Managers.company_id = p_company_id;
    RETURN total_invoices;
END;
$$ LANGUAGE plpgsql;

-- 2. Function to get the average product rating
CREATE OR REPLACE FUNCTION get_product_average_rating(p_product_id INT)
RETURNS NUMERIC AS $$
DECLARE
    avg_rating NUMERIC;
BEGIN
    SELECT AVG(rating) INTO avg_rating
    FROM Survey_Responses
    WHERE product_id = p_product_id;
    RETURN avg_rating;
END;
$$ LANGUAGE plpgsql;

-- 3. Function to get the most frequent product purchased by a customer
CREATE OR REPLACE FUNCTION get_most_frequent_product(p_customer_id INT)
RETURNS TEXT AS $$
DECLARE
    frequent_product TEXT;
BEGIN
    SELECT Products.name
    INTO frequent_product
    FROM Invoice_Items
    JOIN Products ON Invoice_Items.product_id = Products.product_id
    JOIN Invoices ON Invoice_Items.invoice_id = Invoices.invoice_id
    WHERE Invoices.customer_id = p_customer_id
    GROUP BY Products.name
    ORDER BY COUNT(*) DESC
    LIMIT 1;
    RETURN frequent_product;
END;
$$ LANGUAGE plpgsql;

-- 4. Function to calculate total operator rating for a customer
CREATE OR REPLACE FUNCTION get_total_operator_ratings(p_customer_id INT)
RETURNS INT AS $$
DECLARE
    total_ratings INT;
BEGIN
    SELECT COUNT(*) INTO total_ratings
    FROM Operator_Ratings
    WHERE customer_id = p_customer_id;
    RETURN total_ratings;
END;
$$ LANGUAGE plpgsql;

-- 5. Function to check if a product exists in any invoice
CREATE OR REPLACE FUNCTION check_product_in_invoice(p_product_id INT)
RETURNS BOOLEAN AS $$
DECLARE
    product_exists BOOLEAN;
BEGIN
    SELECT EXISTS(
        SELECT 1
        FROM Invoice_Items
        WHERE product_id = p_product_id
    ) INTO product_exists;
    RETURN product_exists;
END;
$$ LANGUAGE plpgsql;

-- 6. Function to get a manager's total survey responses
CREATE OR REPLACE FUNCTION get_manager_survey_responses(p_manager_id INT)
RETURNS INT AS $$
DECLARE
    total_responses INT;
BEGIN
    SELECT COUNT(*) INTO total_responses
    FROM Survey_Responses
    WHERE survey_id IN (SELECT survey_id FROM Surveys WHERE manager_id = p_manager_id);
    RETURN total_responses;
END;
$$ LANGUAGE plpgsql;

-- 7. Function to get the highest rating given to a product
CREATE OR REPLACE FUNCTION get_highest_product_rating(p_product_id INT)
RETURNS INT AS $$
DECLARE
    highest_rating INT;
BEGIN
    SELECT MAX(rating) INTO highest_rating
    FROM Survey_Responses
    WHERE product_id = p_product_id;
    RETURN highest_rating;
END;
$$ LANGUAGE plpgsql;

-- 8. Function to get total sales (products sold) for a manager
CREATE OR REPLACE FUNCTION get_manager_total_sales(p_manager_id INT)
RETURNS INT AS $$
DECLARE
    total_sales INT;
BEGIN
    SELECT COUNT(*) INTO total_sales
    FROM Invoice_Items
    JOIN Invoices ON Invoice_Items.invoice_id = Invoices.invoice_id
    WHERE Invoices.manager_id = p_manager_id;
    RETURN total_sales;
END;
$$ LANGUAGE plpgsql;

-- 9. Function to get total notifications sent to a customer
CREATE OR REPLACE FUNCTION get_customer_notifications_count(p_customer_id INT)
RETURNS INT AS $$
DECLARE
    total_notifications INT;
BEGIN
    SELECT COUNT(*) INTO total_notifications
    FROM Notifications
    WHERE customer_id = p_customer_id;
    RETURN total_notifications;
END;
$$ LANGUAGE plpgsql;

-- 10. Function to get the number of surveys sent to a customer
CREATE OR REPLACE FUNCTION get_customer_surveys_count(p_customer_id INT)
RETURNS INT AS $$
DECLARE
    total_surveys INT;
BEGIN
    SELECT COUNT(*) INTO total_surveys
    FROM Survey_Responses
    WHERE customer_id = p_customer_id;
    RETURN total_surveys;
END;
$$ LANGUAGE plpgsql;


-- 11. Trigger to update invoice total count when a new invoice is added
CREATE OR REPLACE FUNCTION update_invoice_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Companies
    SET invoice_count = invoice_count + 1
    WHERE company_id = (SELECT company_id FROM Managers WHERE manager_id = NEW.manager_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER invoice_count_trigger
AFTER INSERT ON Invoices
FOR EACH ROW
EXECUTE FUNCTION update_invoice_count();


-- 12. Trigger to log changes in product ratings
CREATE OR REPLACE FUNCTION log_rating_change()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Rating_Logs (product_id, old_rating, new_rating, timestamp)
    VALUES (NEW.product_id, OLD.rating, NEW.rating, CURRENT_TIMESTAMP);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER rating_change_trigger
AFTER UPDATE ON Survey_Responses
FOR EACH ROW
WHEN (OLD.rating IS DISTINCT FROM NEW.rating)
EXECUTE FUNCTION log_rating_change();


-- 13. Trigger to delete notifications if the associated customer is deleted
CREATE OR REPLACE FUNCTION delete_notifications_on_customer_delete()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM Notifications WHERE customer_id = OLD.customer_id;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER customer_delete_notification_trigger
AFTER DELETE ON Customers
FOR EACH ROW
EXECUTE FUNCTION delete_notifications_on_customer_delete();


-- 14. Trigger to update the total survey responses when a new survey response is inserted
CREATE OR REPLACE FUNCTION update_manager_survey_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Managers
    SET total_survey_responses = total_survey_responses + 1
    WHERE manager_id = NEW.manager_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER survey_response_trigger
AFTER INSERT ON Survey_Responses
FOR EACH ROW
EXECUTE FUNCTION update_manager_survey_count();


-- 15. Trigger to prevent negative operator ratings
CREATE OR REPLACE FUNCTION prevent_negative_operator_rating()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.operator_rating < 1 THEN
        RAISE EXCEPTION 'Operator rating cannot be less than 1';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER operator_rating_check_trigger
BEFORE INSERT OR UPDATE ON Operator_Ratings
FOR EACH ROW
EXECUTE FUNCTION prevent_negative_operator_rating();


-- 16. Trigger to update the product's average rating whenever a new rating is added
CREATE OR REPLACE FUNCTION update_product_average_rating()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Products
    SET avg_rating = (SELECT AVG(rating) FROM Survey_Responses WHERE product_id = NEW.product_id)
    WHERE product_id = NEW.product_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER product_average_rating_trigger
AFTER INSERT ON Survey_Responses
FOR EACH ROW
EXECUTE FUNCTION update_product_average_rating();


-- 17. Trigger to ensure a unique product code is inserted
CREATE OR REPLACE FUNCTION enforce_unique_product_code()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM Products WHERE unique_code = NEW.unique_code) THEN
        RAISE EXCEPTION 'Product code must be unique';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER unique_product_code_trigger
BEFORE INSERT ON Products
FOR EACH ROW
EXECUTE FUNCTION enforce_unique_product_code();


-- 18. Trigger to set the default invoice status to 'Pending' when created
CREATE OR REPLACE FUNCTION set_invoice_default_status()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Invoices
    SET status = 'Pending'
    WHERE invoice_id = NEW.invoice_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_invoice_status_trigger
AFTER INSERT ON Invoices
FOR EACH ROW
EXECUTE FUNCTION set_invoice_default_status();


-- 19. Trigger to ensure that the invoice item exists in an invoice before deletion
CREATE OR REPLACE FUNCTION ensure_invoice_item_exists()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Invoice_Items WHERE invoice_item_id = OLD.invoice_item_id) THEN
        RAISE EXCEPTION 'Invoice item does not exist';
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER invoice_item_exists_trigger
BEFORE DELETE ON Invoice_Items
FOR EACH ROW
EXECUTE FUNCTION ensure_invoice_item_exists();
