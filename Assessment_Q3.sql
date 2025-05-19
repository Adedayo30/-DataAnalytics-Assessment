USE adashi_staging;

-- In the query below, a derived table (called plan) was used to summarize the plans_plan table
-- The summarized table is then joined with the savings_savingsaccount table
SELECT savings_savingsaccount.plan_id,
plan.owner_id,
plan.t_type AS type,
-- On any plan type, transaction can take place many times but the last transaction date is the max date 
MAX(savings_savingsaccount.transaction_date) AS last_transaction_date,
-- the line below finds the difference between current time and last transaction date
DATEDIFF(NOW(), MAX(savings_savingsaccount.transaction_date)) as inactivity_days
FROM 
	-- below starts the derived table usin plans_plan table
	(
		SELECT id, 
		owner_id,
		CASE 
			WHEN is_a_fund = 1 THEN 'Investment'
			ELSE 'Savings'
		END AS type
        FROM plans_plan 
        -- The filter below is important because there is a need to only the account that has either savings or investment plan
        WHERE is_a_fund = 1 OR is_regular_savings = 1
    ) AS plan(id, owner_id, t_type)  -- set alias for the derived table
-- Join the derived and savings_savingsaccount together
INNER JOIN savings_savingsaccount ON plan.id = savings_savingsaccount.plan_id
GROUP BY savings_savingsaccount.plan_id
-- Show only the account that are in active in last one year
HAVING inactivity_days <= 365
ORDER BY inactivity_days DESC  -- Shows the number of inactive days in descending order
;