
# 📢 Customer Survey & Notification DB System

This project is a relational database system designed to help companies gather customer feedback and send notifications through SMS, email, or phone calls.

## 🧰 Technologies Used
- PostgreSQL (or other RDBMS)
- SQL (DDL, DML, Queries)
- ER Modeling

## 🏗️ Features
- Multi-channel notification system (SMS, Email, Phone)
- Feedback collection from customers (1-5 scale)
- Manager and company relationship management
- Customer-product purchase history
- Operator feedback in phone surveys
- Support for multiple companies surveying the same customer

## 🗃️ Database Schema
- `Companies`: Stores company data and license codes.
- `Managers`: Company managers, linked to one company.
- `Customers`: Customers' personal contact information.
- `Products`: List of products with unique codes.
- `Invoices` & `Invoice_Items`: Purchases and product data.
- `Survey_Results`: Numeric product feedback from customers.
- `Call_Feedback`: Extra ratings for phone operator experience.
- `Notifications`: Tracks content and method of delivery.

## 🧪 Getting Started

To create the database schema, run:

```bash
psql -U your_user -d your_db -f schema/create_tables.sql
```

(Optional: use `pgAdmin`, DBeaver, or SQLite CLI depending on RDBMS)

## 📊 Example Query Files
- `queries/survey_report_queries.sql`: Top-rated products, customer feedback summaries
- `queries/customer_contact_queries.sql`: Customers contacted more than 3 times
- `queries/feedback_analysis.sql`: Operator performance analysis

## 📌 Author
Developed as a course project to demonstrate database schema design and query writing skills.

## 📎 License
MIT
