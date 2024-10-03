# Data migration of sales data Excel sheets to SQL DB
I have sales records of income with some calculations in two Excel sheets and I want to store the data in a PostgreSQL database.

# Database Creation
I have created two tables for my income data, recording daily and weekly income. Only the raw data was transferred from the Excel sheets (most columns containing calculations were not). <br>

[SQL Database Creation](https://github.com/aklesitz/Tip_Income_Analysis/blob/main/tip_income_sql_creation.sql)

# Data Dictionary
* Daily Table
    * 'date': date of shift
    * 'week_of': Pay period shift occurred in
    * 'day': day of the week shift belonged to
    * 'sales': total sales for shift
    * 'cc_tips': total credit card tips made during shift
    * 'cash': total cash tips made during shift
    * 'wine': wine bought for personal consumption
    * 'hours': total hours worked during shift
    * 'pre_tax': credit card tips made plus cash tips made
    * 'shift_type': denotes whether shift was during dinner service or brunch
* Weekly Table
    * 'week_of': Weekly pay period
    * 'cc_tips': Total credit card tips for pay period
    * 'deposit': Actual amount of paycheck (cc tips and hourly minus taxes and tip out)
    * 'total_hours': Total hours worked for week
    * 'avg_hourly': Average hourly rate for the week's shifts
    * 'cash': Total cash tips made for week

# Data Migration
I used the Pandas library to read the Excel sheet where the data was recorded, clean and transform the data to fit the schema, and insert the data into the SQL databases I created. <br>

[Python migration script for Daily table](https://github.com/aklesitz/Tip_Income_Analysis/blob/main/daily_sql_insertion.py) <br>
[Python migration script for Weekly table](https://github.com/aklesitz/Tip_Income_Analysis/blob/main/weekly_sql_insertion.py)

# Next Steps
1. Create linear regression to predict deposit amount from cc tips made (without outliers)
2. Automate migration of new entries in Excel to SQL db
3. Create PowerBI dashboard to track rolling averages of income made and income needed