USE PortfolioRetail

-- EDA Starts
SELECT * FROM retail_data_ready;

-- 1&2. The correlation between DISCOUNT RATE with CLV across different customer segments
WITH DiscountTiers AS (
	SELECT 
		customer_segment,
		customer_id,
		net_CLV,
		CASE
			WHEN discount_usage_rate = 0 THEN '1 - No Discount'
			WHEN discount_usage_rate <= 0.15 THEN '2 - Low Discount'
			WHEN discount_usage_rate <= 0.38 THEN '3 - Medium Discount'
			ELSE '4 - High Discount HUNTER'
		END AS discount_tier
	FROM 
		retail_data_ready
)
SELECT
	customer_segment,
	discount_tier,
	COUNT(customer_id) AS 'total_customer',
	CAST(COUNT(customer_id) * 100.0 / SUM(COUNT(customer_id)) OVER (PARTITION BY customer_segment) AS DECIMAL(5,2)) AS 'percentage_customer',
	ROUND(AVG(net_CLV),2) AS 'avg_net_clv',
	CAST(SUM(net_CLV) * 100.0 / SUM(SUM(net_CLV)) OVER (PARTITION BY customer_segment) AS DECIMAL(5,2)) AS 'percentage_clv'
FROM 
	DiscountTiers
GROUP BY
	customer_segment,
	discount_tier
ORDER BY
	customer_segment,
	discount_tier

-- 3. The correlation between DISCOUNT RATE with Customer Retention
WITH DiscountTiers AS (
	SELECT 
		customer_segment,
		customer_id,
		months_active,
		purchase_frequency,
		CASE
			WHEN discount_usage_rate = 0 THEN '1 - No Discount'
			WHEN discount_usage_rate <= 0.15 THEN '2 - Low Discount'
			WHEN discount_usage_rate <= 0.38 THEN '3 - Medium Discount'
			ELSE '4 - High Discount HUNTER'
		END AS discount_tier
	FROM 
		retail_data_ready
)
SELECT
	customer_segment,
	discount_tier,
	COUNT(customer_id) AS 'total_customer',
	CAST(AVG(months_active * 1.0) AS DECIMAL(5,2)) AS avg_months_active,
	ROUND(AVG(purchase_frequency),2) AS 'avg_purchase_freq'
FROM 
	DiscountTiers
GROUP BY
	customer_segment,
	discount_tier
ORDER BY
	customer_segment,
	discount_tier

--4. What distinguish high value customers from occasional buyers?
SELECT
	customer_segment,
	ROUND(AVG(age * 1.0),1) AS Age,
	ROUND(AVG(purchase_frequency * 1.0),1) AS PurchaseFrequency,
	ROUND(AVG(browsing_time_minutes * 1.0),1) AS BrowsingTimeInMinutes,
	ROUND(AVG(support_interactions * 1.0),1) AS SupportInteractions
FROM
	retail_data_ready
WHERE 
	customer_segment IN ('High_Value', 'Occasional')
GROUP BY
	customer_segment

-- Metric: payment method
SELECT 
	customer_segment,
	payment_method,
	COUNT(customer_id) AS TotalUssage,
	CAST(COUNT(customer_id) * 100.0 / SUM(COUNT(customer_id)) OVER(PARTITION BY customer_segment) AS DECIMAL(5,2)) AS percentage_usage
FROM 
	retail_data_ready
WHERE 
    customer_segment IN ('High_Value', 'Occasional')
GROUP BY 
    customer_segment,
    payment_method
ORDER BY 
    customer_segment, 
    percentage_usage DESC;