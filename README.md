# Online Retail Customer: CLV & Behavioral Profiling Analysis
> A comprehensive **End-to-End Diagnostic Analysis** using MS Excel, Power Query, and Tableau to uncover the behavioral and operational drivers behind customer retention and profitability.

## Table of Contents
1. [Business Understanding](#business-understanding)
2. [Data Source](#data-source)
3. [Cloud Environments & Tech Stack](#cloud-environments--tech-stack)
4. [Data Cleaning](#data-cleaning)
5. [Data Extraction & Feature Engineering](#data-extraction--feature-engineering)
6. [Key Findings (Summary)](#key-findings-summary)
7. [Dashboard](#dashboard)
8. [Recommendation Actions](#recommendation-actions)
---
## 1. Business Understanding
### 1.1 Business Background
Online Retail Customer is a fictional, structured customer behavior dataset gathered from an online retail environment (Kaggle). The dataset categorizes customers into four segments: **Occasional** (Low engagement and transactional activity), **Regular** (Moderate purchasing consistency), **Loyal** (High engagement and repeat behavior), and **High Value** (Top-tier customers with strong lifetime value signals).

The dataset tracks customer behavior on both a daily and monthly basis, highlighting key metrics like purchase frequency and browsing time.
### 1.2 Business Problem
Although the platform captures rich customer behavior metrics on a daily and monthly basis, management has yet to utilize this data to understand the underlying drivers of each customer segment. This knowledge gap has led to two critical business challenges:
- **Problem 1: Promotion & Discount Inefficiency**: The company cannot distinguish whether high discount usage rates genuinely drive long-term customer loyalty. The company urgently needs to identify which customer segments rely too heavily on promotions to optimize the marketing budget.
- **Problem 2: Unclear Behavioral Drivers for Upselling**: Management cannot identify the specific daily and monthly behaviors (such as browsing time or payment method preferences) that successfully transition an 'Occasional' buyer into a 'High-Value' customer, making it difficult to design targeted engagement strategies.
### 1.3 Project Objectives
| No   | Objective     | Analysis Focus|
|-----:|---------------|---------------|
|     1| Identify customers who are genuinely loyal versus those who are merely promotion-dependent.  | Promotion Sensitivity Analysis & Customer Lifetime Value (CLV) Assessment |
|     2| Identify drivers for upselling |Behavioral Profiling & Customer Journey Diagnostics |
### 1.4 Key Business Questions (KBQ)
**Objective 1—Promotion Sensitivity Analysis & CLV**
- How does the discount rate correlate with customer lifetime value indicators across different customer segments?
- Are "High Value" customers genuinely loyal (maintaining high spending with low discount usage), or are their high transaction values driven by promotions?
- Does a higher dependency on discounts correlate with longer retention? Or do highly promotion-sensitive customers leave just as quickly?

**Objective 2—Behavioral Profiling & Customer Journey Diagnostics**
- What specific behaviors distinguish "High Value" customers from "Occasional" buyers?
- Are there any specific transactional preferences (payment method/geographic advantage) that strongly characterize the "High Value" segment and can be leveraged for upselling campaigns?
---
## 2. Data Source
**Platform:** Kaggle
**Dataset:** [Click here](https://www.kaggle.com/datasets/rohit8527kmr7518/online-retail-customer-classification-dataset)
| Column | Description |
|-----:|---------------|
| customer_id | Unique customer identifier.   |
| age | Customer age (18–70). Includes a nonlinear relationship with the target.               |
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
<img width="1280" height="720" alt="Data Analytics Workflow" src="https://github.com/user-attachments/assets/f0e83792-02cf-4ac3-ab9b-6a0480271186" />

---
## 4. Data Cleaning
All cleaning was performed in Google Colab using Python, producing a cleaned table for analysis.
### 4.1 Cleaning Strategy per Column
`customer_id`
- Removed duplicate rows based on customer_id to ensure each customer is uniquely represented and to prevent double-counting.
  
`annual_income`
- Made sure the dtype is float
- Checked whether there are null values in the "annual_income" column
- Handled null values in the `annual_income` column via conditional median imputation, grouped by `region` and `customer_segment`

`purchase_frequency`
- Made sure the dtype is float
- Handled all the missing values by converting "null" to "0" (assumed the null values mean the customer hasn't made any purchases yet)

`avg_monthly_spend`
- Made sure the dtype is float
- Checked whether there are null values in the "avg_monthly_spend" column
- Recovered missing records not by estimation, but by mathematically reverse-engineering the dataset's native derivation formula. Imputed nulls using the exact calculation: avg_order_value * (purchase_frequency + 1)

`discount_usage_rate`
- Replaced null values with 0. Logically deduced that missing proportions occur either because of a lack of transaction history (purchase_frequency = 0) or because purchases were made entirely at full price without applied discounts

`return_rate`
- Replaced null values with 0. Nulls logically indicate no items were returned

`browsing_time_minutes`
- Avoided zero-filling to prevent artificial downward skewing of time metrics. Imputed nulls using the median browsing time grouped by customer_segment to preserve the natural distribution of user engagement

`support_interactions`
- Handled all the missing values by converting "null" to "0"
- Converted the column from float to int

`payment_method`, `region`, `customer_segment`
- Made sure there are no null values

---
## 5. Data Extraction & Feature Engineering
### 5.1 Customer Lifetime Value (CLV) Calculation
Customer Lifetime Value (CLV) was calculated in two steps:
1. `gross_CLV`: the customer lifetime value = `avg_monthly_spend` * `months_active`
2. `net_CLV`: the customer lifetime value minus the return rate = `gross_CLV` * (1-`return_rate`)

### 5.2 Discount Usage Segmentation 
To analyze the impact of promotions (discount rate) on customer profitability, I categorized customers into tiers based on their `discount_usage_rate`.

Rather than relying on arbitrary assumptions, I applied a data-driven approach using the dataset's distribution (quartiles) to establish logical thresholds:
* **1 - No Discount:** Customers with a 0% discount rate.
* **2 - Low Usage:** Customers below the 25th percentile (Q1).
* **3 - Medium Usage:** Customers between the 25th and 75th percentiles (Q1 - Q3).
* **4 - High Discount Hunter:** Customers above the 75th percentile (Q3).

---
## 6. Key Findings
EDA was processed using SQL. Full code: [SQL for EDA]()

---
### Finding 1: "Promo Addiction" phenomenon in each segment: The majority are not buying at full price

<img width="473" height="213" alt="image" src="https://github.com/user-attachments/assets/95e4b617-66b9-464d-98fe-04d3a2831503" />

**The insight:** Across all customer segments, a staggering **~70% to 75%** of the total customer base relies heavily on promotions, falling primarily into the 'Medium Discount' and 'High Discount Hunter' tiers. Conversely, only a mere **~5%** of customers across the board are willing to transact at full price ('No Discount').

**Why it matters:** This reveals a severe "promo addiction" embedded in the current consumer behavior. The business has inadvertently trained its audience to wait for markdowns before making a purchase. While this mass-discounting strategy may drive short-term transaction volume, it creates an unsustainable revenue model where profit margins are constantly cannibalized just to maintain baseline sales.

---
### Finding 2: High transactions on "High Value" customers are mostly driven by promotions

<img width="453" height="386" alt="1 - Discount Usage Distribution Visualization" src="https://github.com/user-attachments/assets/76d85df5-6917-4736-ba01-7fe0646d55b2" />

**The insight:** The discount tier distribution within the "High Value" customer segment reveals that more than half of these top spenders (50.6%) fall into the Medium Discount category. The second largest group consists of High Discount Hunters at 22.76%, closely followed by the Low Discount tier at 22.14%. In stark contrast, customers who purchase at full price (No Discount) rank dead last, making up a mere 5.06% of this premium segment.

**Why it matters:** This distribution mathematically disproves the assumption of organic brand loyalty among top-tier spenders. It highlights that even within the "High Value" label, purchasing behavior is predominantly driven by promotions and discounts rather than genuine brand affinity.

---
### Finding 3: Discounts Do Not Buy Loyalty (Zero Correlation with Retention)

<img width="331" height="168" alt="screenshot of findings" src="https://github.com/user-attachments/assets/b1049414-d458-400e-91f4-d090111c2eca" />

<br>

<img width="601" height="388" alt="2 - Discount and Retention Correlation" src="https://github.com/user-attachments/assets/eb27fc13-eb53-4f4b-9634-386db97a3a67" />


**The insight:** 
An analysis of customer tenure (`avg_months_active`) reveals a completely flat retention curve across all discount tiers within any given segment. For instance, in the 'High Value' segment, customers who consistently pay full price remain active for an average of 54.8 months, while extreme 'High Discount Hunters' churn at 54.2 months. 

**Why it matters:** 
This answers whether discounts extend customer lifespan: they do not. Highly promotion-sensitive customers leave just as quickly as non-discounted ones. Customer retention is dictated entirely by the segment's natural lifecycle, not by promotional incentives. Consequently, aggressively discounting products to retain customers longer is a flawed strategy that only accelerates margin erosion without improving loyalty.

---
### Finding 4: High-Value Status is Driven by Habit, Not Demographics or Transactional Preferences

<img width="320" height="148" alt="image" src="https://github.com/user-attachments/assets/00a82a84-e78f-497c-9367-760664ed481c" />

**The insight:**
Contrary to common assumptions, there are virtually no differences in demographics (`age`), operational friction (`support_interactions`), or transactional preferences (`payment_method`) between 'High Value' and 'Occasional' buyers. Both segments average 43-44 years of age, experience the same minimal need for customer support (~1.4 interactions), and share identical payment habits (dominated by Credit/Debit Cards at ~50%). The single most definitive differentiator is purely behavioral: purchase frequency (8.29 vs. 3.13 transactions).

**Why it matters:** 
This proves that the operational bottleneck (such as payment method or customer service) is not the barrier preventing "Occasional" buyers from upgrading to top-tier status. It also indicates that demographic-targeted marketing or exclusive payment-method promotions will yield minimal impact. To successfully migrate customers into the 'High Value' segment, the business must pivot toward habit-forming strategies—such as personalized lifecycle nudges and engagement triggers—designed strictly to accelerate purchase frequency.

---
### Finding 5: The limitation of synthetic data

**Why it matters:**
The analysis is based on a synthetic snapshot dataset aggregated at the customer level. As it lacks timestamp transactional logs (SKU-level detail) and exhibits perfectly uniform categorical distributions, seasonal trend analysis and Market Basket Analysis were out of scope. The insights focus strictly on macro-behavioral segmentation and static CLV metrics.

---
## 7. Dashboard
Designed as a narrative arc to tell all the findings.

[➡️Open dashboard on Tableau](https://public.tableau.com/app/profile/caroline.harmanto/viz/CustomerBehavioralAnalysis_17913008423020/Dashboard1?publish=yes)

<img width="677" height="386" alt="(Final) Dashboard" src="https://github.com/user-attachments/assets/e61b113f-5d17-4ca8-9e22-e34c80c0fa58" />

**Layout:**
- **Top Row:** KPI Score stating the number of customers, average Customer Lifetime Value (CLV), average purchase frequency, and average customer months active.
- **Upper Section:** Segment-based comparison highlighting customer habits: including discount usage, platform engagement (browsing time & purchasing frequency), and payment preference.
- **Bottom Section:** Correlation analysis evaluating the impact of discount tiers on customer retention and overall CLV.

---
## 8. Insight & Recommended Actions

### 8.1: Key Findings Summary
**Objective 1—Promotion Sensitivity Analysis & CLV**
1. ~95% of the total customers in each segment rely heavily on promotions, falling primarily into the "Medium Discount" and "High Discount Hunter" tiers. However, the CLV does not increase significantly. Contrary to the 'promo-addiction' assumption, higher discount rates do not produce higher CLV. Behavioral profiling shows that each customer segment shares nearly identical discount-usage distributions. 
2. If customer loyalty is defined by maintaining high spending with low discount usage, the "High Value" segment fails this criterion, as they rely on promos just as heavily as occasional buyers.
3. No, a higher dependency on discounts does not correlate with longer retention. Highly promotion-sensitive customers leave just as quickly as those who receive no discounts, evidenced by the flat retention curves across all tiers. The data shows that retention is driven entirely by customer segmentation: "High Value" customers (across all discount tiers) are more active than "Regular" and "Occasional" customers.

**Objective 2—Behavioral Profiling & Customer Journey Diagnostics**
1. "High Value" customers show significantly higher purchase volumes than "Occasional" buyers, demonstrating genuine loyalty. 
2. While "High Value" customers show a slight preference for card payments, the variance across payment methods is marginal. This indicates that transactional preferences do not strongly characterize the segment. Therefore, upselling campaigns should not focus on specific payment channels, but rather on driving core platform engagement and habitual purchasing.

---
### 8.2: Strategic Pivot: Reconstruct the Promotion Allocation for All Customer Segments
**Problem:** Data reveals a systemic over-reliance on promotional discounts across all customer segments, which wasted profit margins without improving Customer Lifetime Value (CLV) or extending retention.
**Approach:** Pivot promotional spend away from high-tier discounts and invest in campaigns that drive core platform engagement. Focus on nurturing habit-forming customer journeys that naturally increase transaction frequency and strengthen brand connection. 

---
### 8.3: For "High Value" Customers: Focus on Margin Protection & Habit Maintenance
**Problem:** The defining characteristic of "High Value" customers is their exceptional purchase frequency. However, because they still heavily rely on promotions, the business faces the challenge of deliberately sustaining this high-frequency habit without continuously eroding profit margins through deep discounts.
**Approach**:
- Transition to Experiential Rewards: Shift away from cash discounts and introduce non-monetary VIP perks (e.g., priority shipping, early access to new collections, or exclusive support lanes) to reward loyalty while protecting margins.
- Implement Habit-Based Gamification: Leverage their natural tendency to purchase frequently by introducing streak-based milestones (e.g., "Complete 4 consecutive weeks of purchases to maintain VIP status"). This reinforces the habit loop without relying on financial incentives.

---
### 8.4: For "Occasional" Buyers: Focus on Habit Activation & Frequency Building
**Problem:** These customers exhibit low platform engagement, with their limited transactions driven almost entirely by high-tier promotions rather than brand loyalty.
**Approach:**
- Deploy Trigger-Based Marketing Campaigns: Since payment methods are not a friction point, the root cause of low lifetime value is strictly a lack of engagement. Pivot email and push notification strategies from generic discount blasts to habit-forming behavioral triggers, such as personalized repurchase reminders or tailored product recommendations based on past behavior.
- Optimize the Time-Between-Purchases Window: Given the significantly shorter lifespan (average active months) of these segments, early intervention is critical. Design targeted campaigns aimed at accelerating the second and third purchases within a tight timeframe (e.g., the first 30 days). The objective is to engineer habitual engagement before the churn risk peaks.

---
Dataset: [Kaggle](https://www.kaggle.com/datasets/rohit8527kmr7518/online-retail-customer-classification-dataset)
Data Cleaning & Preprocessing: [Google Colab](https://colab.research.google.com/drive/10RWDmGnf4o6dg4Ur6ldoeQxMXEd7lxPU?usp=sharing)
EDA: [SQL](https://github.com/carolinegraciela/RetailCustomer-Analysis-Project/blob/main/EDA_query.sql)
Visualizaion: [Tableau](https://public.tableau.com/app/profile/caroline.harmanto/viz/CustomerBehavioralAnalysis_17913008423020/Dashboard1?publish=yes)
