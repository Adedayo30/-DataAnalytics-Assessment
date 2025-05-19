USE `adashi_staging`;

-- The block of codes below contains a derived table. 
-- Therefore, the initial "select from" you see just below this comment is fetching from the internal derived table

SELECT save.owner_id,
CONCAT(users_customuser.first_name, ' ', users_customuser.last_name) AS name, -- customer's fullname
-- Sum up each customer's plan. Sum is used because the column contains 0s and 1s
SUM(plans_plan.is_regular_savings) AS savings_count, 
SUM(plans_plan.is_a_fund) AS investment_count, total_deposits
FROM
	(	
		-- the columns for amount are in kobo, therefore it will be converted to Naira by dividing it wiht 100
		SELECT owner_id, ROUND(SUM(confirmed_amount)/100,2) AS total_deposits
		FROM savings_savingsaccount
		GROUP BY owner_id
    ) AS save(owner_id, total_deposits)
-- join the derived table with other necessary tables
INNER JOIN plans_plan ON save.owner_id = plans_plan.owner_id
INNER JOIN users_customuser ON users_customuser.id = save.owner_id
-- group the result by the user id
GROUP BY users_customuser.id
-- select the condition which is customers that have both savings and investment plan
HAVING savings_count > 0 AND investment_count > 0;
