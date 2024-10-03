import pandas as pd
from sqlalchemy import create_engine, text
from dotenv import load_dotenv
import os

# Load env variables from .env file
load_dotenv()

# Database variables
db_name = os.getenv('DB_NAME')
db_user = os.getenv('DB_USER')
db_password = os.getenv('DB_PASSWORD')
db_host = os.getenv('DB_HOST')
db_port = os. getenv('DB_PORT')

# Excel File Path
excel_file_path = os.getenv('EXCEL_FILE_PATH')
sheet_name = os.getenv('WEEKLY_EXCEL_SHEET')

# PostgreSQL table name
table_name = 'weekly'

# Define Postgre connection URL
db_url = f'postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}'

# Create engine to connect to database
engine = create_engine(db_url)

# Read Excel sheet into df
df = pd.read_excel(excel_file_path, sheet_name=sheet_name, header=None)

# Retrieving and adding column names from SQL db
with engine.connect() as conn:
    result = conn.execute(text(f"""
        SELECT column_name 
        FROM information_schema.columns 
        WHERE table_name = '{table_name}'
        ORDER BY ordinal_position;
        """))
    sql_table_columns_weekly = [row[0] for row in result]

# Cleaning dataframe
print(df)
print(sql_table_columns_weekly)

df = df.iloc[:-10]
df = df.iloc[:, :-12]
df = df.drop(df.columns[[3, 4, 5, 9, 10, 11]], axis=1)
df = df.drop([0])
df.columns = sql_table_columns_weekly

# Convert columns to numeric and round to two decimal places
df.dtypes
weekly_numeric_columns = ['cc_tips', 'deposit', 'total_hours', 'avg_hourly', 'cash']
df[weekly_numeric_columns] = df[weekly_numeric_columns].apply(pd.to_numeric).round(2)

# Insert data into PostgreSQL db
df.to_sql(table_name, engine, if_exists='replace', index=False)

print("Data inserted successfully!")