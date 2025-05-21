# -DataAnalytics-Assessment
## Q1: High-Value Customers with Multiple Products
### Approach
I concatenated the first name and last name of each customer in order to get each customer’s full name using the users_customuser table. Furthermore, I made attempt to check whether the owner_id in plans_plan table was unique or not: I found it unique. In addition, I then wrote another query to summarize the amount for each customer in savings_savingsaccount table and group the result by owner_id. This is necessary because some customers made more than one transaction.  Each of these queries were created separately in order to be sure that I got the desired result. I then copied one query into another as the task required and linked the three of them using the owner_id. The final result here is in Naira and not kobo
### Challenges
While I was copying the queries into one another, I tried to test each time I made a change. When I linked plans_plan and users_customers tables together, there was no issue but when I connected the savings_savingsaccount, problem arose because the owner_id that I was using for the joining was not unique in savings_savingsaccount table. I tackled this challenge by summarizing the savings_savingsaccount table separately and grouped the result by owner_id. I was able to join this summary with other tables by referencing it as a derived table.

## Q2: Transaction Frequency Analysis
### Approach
I wrote different queries independently like I did for Q1. The question asked for monthly average and there was no month name in the savings_savingsaccount table. Therefore, my first approach was to write a query that could form month name using the transaction_date. In order to know the frequency of transaction by each customer, I counted the number of transactions each customer made in each month and use CASE function to categorize the result into different categories as specified in the question. I grouped the results by owner_id and month_name. 
I then wrote another query that could summarize the result I got above by aggregating the average of total transaction made by all the customers in each month. This was grouped by frequency category and month each customer belongs. 
Finally, I wrote another query to furthermore summarize the result gotten above by aggregating the average transaction made each month. 

### Challenges
The challenge I faced here was “how I could link two derived tables” together and with another table. I was able to overcome this by setting alias for each derived table. I called each derived table by its alias and use it in the other parts of the query. (I also browsed to Google to get information about).

## Q3: Account Inactivity Alert
### Approach
I saw in the question that there was transaction category which is not present in any table in this database. I used the plans_plan table to figure this out. I first check whether there was any record in that table that has both investment and savings plan in the same row but there was none. This assurance made me set “Investment” where is_a_fund is 1 and “Savings” for the rest meanwhile this column will be filtered, only those who have plans will appear. To get the last transaction date, I calculated the maximum transaction date per customer. Furthermore, I then calculated the difference between current date/time and last transaction date. All these were then joined together using id
##  Challenges
There was no big challenge here except when I was trying to manipulate the transaction dates. If I subtracted any figure from the date, it would subtract it from the seconds. I resolved into using DATEDIFF function.

## Q4: Customer Lifetime Value (CLV) Estimation
### Approach
I used users_customuser table to get the customer_id, name and tenure_months.  The tenure_months was calculated by using TIMESTAMPDIFF function to get the number of months between the date the customer signed up and current date/time. I then summarized the total transactions per customer using the savings_savingsaccount table. In addition, I used the formula given in the instruction to get the clv. The two tables were joined together with the required column already selected.
### Challenges
Calculating the clv was not quickly gotten but after few minutes I figured it out.
