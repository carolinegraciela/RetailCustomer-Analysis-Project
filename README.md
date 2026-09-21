# Online Retail Customer: CLV & Behavioral Profiling Analysis
> A comprehensive **End-to-End Diagnostic & Prescriptive Analysis** using MS Excel, Power Query, and Tableau to uncover the behavioral and operational drivers behind customer retention and profitability.

## Table of Contents
1. Business Understanding
2. Data Source
3. Cloud Environments & Tech Stack
4. Data Cleaning
5. Data Extraction & Feature Engineering
6. Key Findings (Summary)
7. Dashboard
8. Recommendation Actions
---
## 1. Business Understanding
### 1.1 Business Background
Online Retail Customer is a fictional structured customer behavior dataset gathered from an online retail environment (Kaggle). The dataset categorizes customers into four segments: **Occasional** (Low engagement and transactional activity), **Regular** (Moderate purchasing consistency), **Loyal** (High engagement and repeat behavior), and **High Value** (Top-tier customers with strong lifetime value signals).

The dataset tracks customer behavior on both a daily and monthly basis, highlighting key metrics like purchase frequency and browsing time.
### 1.2 Business Problem
Although the platform captures rich customer behavior metrics on a daily and monthly basis, management has yet to utilize this data to understand the underlying drivers of each customer segment. This knowledge gap has led to two critical business challenges:
- **Problem 1: Promotion & Discount Inefficiency**: The company cannot distinguish whether high discount usage rates genuinely drive long-term customer loyalty. There is an urgent need to identify which customer segments are overly reliant on promotions to optimize the marketing budget.
- **Problem 2: Unclear Behavioral Drivers for Upselling**: Management cannot identify the specific daily and monthly behaviors (such as browsing time or payment method preferences) that successfully transition an 'Occasional' buyer into a 'High-Value' customer, making it difficult to design targeted engagement strategies.
### 1.3 Project Objectives
| No   | Objective     | Analysis Focus|
|-----:|---------------|---------------|
|     1| Identify customers who are genuinely loyal versus those who are merely promotion-dependent.  | Promotion Sensitivity Analysis & Customer Lifetime Value (CLV) Assessment |
|     2| Identify drivers for upselling |Behavioral Profiling & Customer Journey Diagnostics |
### 1.4 Key Business Questions (KBQ)
**Objective 1—Promotion Sensitivity Analysis & CLV**
- How does the discount rate correlate with customer lifetime valur indicators accross different customer segments?
- Are "High Value" customers genuinely loyal (maintaining high spending with low discount usage), or are their high transaction values driven by promotions?
- Does a higher dependency on discount correlate with longer retention? Or do highly promotion-sensitive customers leave just as quickly?

**Objective 2—Behavioral Profiling & Customer Journey Diagnostics**
- What specific behavior that distinguish "High Value" customers from "Occasional" buyers?
- To what extend do operational friction points (such as return rate and support interactions) act as a bottleneck preventing "Occasional" customers from upgrading their segment?
- Are there any specific transactional preference (payment method/geographic advantage) that strongly characterize the "High Value" segment and can be leveraged for upselling campaigns?
---
## 2. Data Source
**Platform:** Kaggle
**Dataset:** [Click here](https://www.kaggle.com/datasets/rohit8527kmr7518/online-retail-customer-classification-dataset)
| Column | Description |
|-----:|---------------|
| customer_id | Unique customer identifier.   |
| age | Customer age (18–70). Includes nonlinear relationship with target.               |
| annual_income | Log-normally distributed income with mild outliers. |
| months_active	|	Number of months active on platform. |
| avg_monthly_spend |	Average monthly expenditure (right-skewed). |
| purchase_frequency |	Average purchases per month. |
| avg_order_value |	Derived feature: avg_monthly_spend / (purchase_frequency + 1) |
| discount_usage_rate |	Proportion of purchases using discounts (0–1). |
| return_rate |	Proportion of returned purchases (0–1). |
| browsing_time_minutes	|	Average browsing time per session. |
| support_interactions	|	Number of support contacts (Poisson distributed). |
| payment_method	| Primary payment method (Card, UPI, Wallet). |
| region |	Region classification (Urban, Semi-Urban, Rural). |
| customer_segment	|	Target variable (multiclass). |

---
## 3. Cloud Environment & Tech Stack
<img width="1280" height="720" alt="Data Analytics Workflow" src="https://github.com/user-attachments/assets/31681eb1-76fc-4a95-b5c9-eb4370558aff" />

---
## 4. Data Cleaning
All cleaning was performed in Microsoft Excel and Power Query, producing cleaned table for analysis.
### 4.1 Cleaning Strategy per Column
`customer_id`
- Removed duplicate rows based on customer_id to ensure each customer is uniquely represented and to prevent double-counting.
  
`annual_income`
- Converted the column from Text to Currency to enable mathematical aggregations
- Checking whether there are null values in the "annual_income" column
- Handled null values in the `annual_income` column via conditional median imputation, grouped by `region` and `customer_segment`

`avg_monthly_spend`
- Converted the column from Text to Currency to enable mathematical aggregations
- Checking whether there are null values in the "avg_monthly_spend" column
- Applied conditional logic via Power Query: replaced nulls with 0 for non-transacting leads (purchase_frequency = 0), and imputed missing spending data for active buyers (purchase_frequency > 0) using the formula: (purchase_frequency * avg_order_value) / months_active.
