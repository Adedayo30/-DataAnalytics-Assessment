USE `adashi_staging`;

-- The block of codes below contains 2 derived tables:
-- The inner most derived table was used to calculate the avarage transaction per customers in a month
-- The upper derived table was used to to calculate the average transaction per month
-- The outermost layer was used to group the average transaction per month into each transaction frequency
-- Transaction frequency is given by:
--     transaction count >= 10 = High Frequency
--     transaction count >= 10 = Medium Frequency
--     transaction count >= 10 = Low Frequency     
SELECT frequency_category,
SUM(customer_count) AS customer_count, 
ROUND(AVG(avg_transaction_per_customer),2)  AS avg_transactions_per_month	
FROM
	(
		SELECT frequency_category,
		month_name,
		SUM(transaction_count) AS customer_count,
		ROUND(AVG(transaction_count),2) AS avg_transaction_per_customer
		FROM
			(
				SELECT owner_id,
				MONTHNAME(transaction_date) AS month_name,
				COUNT(transaction_date) AS transaction_count,
				CASE
					WHEN COUNT(transaction_date) >= 10 Then 'High Frequency'
					WHEN COUNT(transaction_date) >=3 AND COUNT(transaction_date) <= 9 THEN 'Medium frequency'
					ELSE 'Low Frequency'
				END AS frequency_category
				FROM savings_savingsaccount 
				GROUP BY owner_id, month_name
				ORDER BY transaction_count DESC
			) AS customer_avg(owner_id, month_name, transaction_count, frequency_category)
		-- Below is the result from the semi outer derived table: this shows customers' average transaction per month
		GROUP BY frequency_category, month_name
	) AS avg_per_cust_per_month(frequency_category, month_name, customer_count, avg_transaction_per_customer)
    -- Below is the result from the final out: this shows monthly average transaction per frequency
    GROUP BY avg_per_cust_per_month.frequency_category
;