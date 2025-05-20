USE adashi_staging;

-- user id, name and tenure are beind derived from the customers' table and joined with the savings history
SELECT 
	user_details.id, user_details.fname AS name,
	user_details.tenure AS tenure_months,
	-- get the total savings amount
	SUM(savings_savingsaccount.confirmed_amount) AS total_transactions,
	-- get the Customer Lifetime Value (clv)
	SUM(savings_savingsaccount.confirmed_amount)/user_details.tenure * 12 * AVG(savings_savingsaccount.confirmed_amount * 0.001) as estimated_clv
	FROM 
		(
			SELECT id,
			CONCAT(users_customuser.first_name, ' ', users_customuser.last_name) AS fname, -- customer's full name
			TIMESTAMPDIFF(MONTH, date_joined, now()) AS tenure  -- date difference by number of months
			FROM users_customuser
		) user_details(id, fname, tenure)  -- derived table alias
	-- link the 2 tables together
	INNER JOIN savings_savingsaccount ON savings_savingsaccount.owner_id = user_details.id
	GROUP BY savings_savingsaccount.owner_id
;