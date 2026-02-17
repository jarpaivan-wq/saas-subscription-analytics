# 📊 SaaS Subscription Analytics - SQL Project

A comprehensive SQL analysis project for a SaaS platform, focusing on revenue tracking, churn analysis, feature adoption, customer lifetime value, and user risk identification.

## 📋 Business Context

CloudMetrics Pro is a SaaS data analytics platform serving small and medium businesses. The company needed data-driven insights to:
- Track Monthly Recurring Revenue (MRR) by subscription plan
- Monitor subscription cancellation trends
- Understand feature adoption across different plans
- Calculate Customer Lifetime Value (CLV) per plan
- Proactively identify users at risk of churning

## 🎯 Key Business Questions Answered

1. **MRR Tracking**: How much recurring revenue is each plan generating monthly?
2. **Cancellation Trends**: How many subscriptions are being cancelled each month?
3. **Feature Adoption**: Which features are most used by active subscribers per plan?
4. **Customer Lifetime Value**: What is the average revenue and subscription duration per plan?
5. **Churn Risk**: Which active users show low engagement and may cancel soon?

## 🗄️ Database Schema

The database consists of 6 interconnected tables:

- **usuarios** (20 records) - Registered customer information
- **planes** (4 plans) - Subscription tiers: Free, Starter, Professional, Enterprise
- **suscripciones** (83 records) - Subscription history per user
- **pagos** (79 records) - Payment transactions
- **features** (12 records) - Platform functionalities
- **uso_features** (58 records) - Feature usage tracking per user

## 📁 Project Structure

```
saas-sql-analysis/
│
├── README.md
├── sql/
│   ├── 01_schema.sql          # Database schema
│   ├── 02_data.sql            # Sample data
│   └── 03_queries.sql         # Business queries
│
├── docs/
│   └── business_questions.md  # Detailed query documentation
│
├── .gitignore
└── LICENSE
```

## 🚀 Getting Started

### Prerequisites
- MySQL 8.0 or higher
- Any SQL client (MySQL Workbench, DBeaver, etc.)

### Setup Instructions

1. **Create Database**
```sql
CREATE DATABASE saas_analytics;
USE saas_analytics;
```

2. **Execute Schema**
```bash
Run sql/01_schema.sql
```

3. **Load Sample Data**
```bash
Run sql/02_data.sql
```

4. **Run Queries**
```bash
Execute queries from sql/03_queries.sql
```

## 💡 Key Insights

- **MRR**: Enterprise plan generates highest revenue contribution
- **Cancellations**: Monitored monthly to detect early churn signals
- **Feature Adoption**: Higher-tier plans show broader feature utilization
- **CLV**: Enterprise users show highest lifetime value
- **Risk Detection**: Users with fewer than 5 interactions in 30 days flagged for re-engagement

## 🛠️ Technologies Used

- **MySQL** - Database management
- **SQL** - Query language
- **DBeaver** - Database client

## 📚 SQL Concepts Demonstrated

- Complex JOINs (INNER JOIN across multiple tables)
- Common Table Expressions (CTEs)
- Aggregate Functions (SUM, COUNT, AVG, MAX)
- Conditional Logic (CASE statements)
- Date Functions (DATE_FORMAT, DATEDIFF, TIMESTAMPDIFF, INTERVAL)
- GROUP BY with HAVING clauses
- Subqueries and derived tables
- Window-style calculations using CTEs

## 📈 Future Enhancements

- Add cohort analysis for user retention
- Build revenue forecasting queries
- Implement advanced churn prediction scoring
- Create feature adoption funnel analysis
- Add geographic revenue breakdown

## 📧 Contact

Created for portfolio demonstration - SQL analytics for SaaS industry

---

⭐ If you found this project useful, please consider giving it a star!

## Appendix: Advanced SQL Analysis

# Advanced Query 13: Top 5 Subscriptions by Monthly Revenue

## 📊 Business Question
Which subscriptions generate the highest average monthly revenue? This analysis normalizes total payments by subscription duration to identify the most valuable customers on a monthly basis.

## 🎯 Technical Complexity
**Level:** ⭐⭐⭐⭐ Advanced

**Key Concepts Demonstrated:**
- TIMESTAMPDIFF for date calculations
- COALESCE for handling NULL dates (active subscriptions)
- NULLIF for division by zero protection
- CTE pattern for filtering window functions
- DENSE_RANK for ranking with ties
- Multiple aggregation levels

## 💡 Query Structure

### CTE1: Active Months Calculation
Uses TIMESTAMPDIFF to calculate subscription duration in months. Handles active subscriptions (fecha_fin = NULL) by using CURDATE().

### CTE2: Total Payments
Aggregates all payments per subscription using SUM.

### CTE3: Monthly Revenue with Ranking
- Divides total payments by active months
- Protects against division by zero with NULLIF
- Applies DENSE_RANK to identify top performers

### Final Query
Filters to show only top 5 subscriptions by monthly revenue.

## 📈 Output Columns
- `nombre_usuario`: Subscriber name
- `nombre_plan`: Subscription plan name
- `meses_activos`: Duration of subscription in months
- `monto_pago`: Total amount paid
- `ingreso_mensual`: Average monthly revenue (total ÷ months)
- `ranking_general`: Global ranking (1 = highest monthly revenue)

## 🎓 Business Value
- **Customer Prioritization:** Focus customer success efforts on high-value accounts
- **LTV Analysis:** Understand lifetime value normalized by duration
- **Upsell Opportunities:** Identify customers with high engagement
- **Churn Prevention:** Proactively engage most valuable subscribers
- **Fair Comparison:** Compare subscriptions regardless of signup date

## 🔧 Technical Notes

### CTE Filtering Pattern
Window functions cannot be filtered in the same query level where they're calculated. Solution: calculate ranking in CTE3, filter in final SELECT.

### NULL Handling
- **COALESCE(fecha_fin, CURDATE())**: Treats active subscriptions (NULL end date) as ending today
- **NULLIF(meses_activos, 0)**: Prevents division by zero for subscriptions with 0 months

## 🔗 File
`saas_04_queries_monthly_revenue_top5`

---

