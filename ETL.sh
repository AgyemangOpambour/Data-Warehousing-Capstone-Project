#!/bin/sh

## Write your code here to load the data from sales_data table in Mysql server to a sales.csv.
## Select the data which is not more than 4 hours old from the current time.



 export PGPASSWORD=<Replace this with your PostgreSQLserver password>;



 psql --username=postgres --host=localhost --dbname=sales_new -c "\COPY sales_data(rowid,product_id,customer_id,price,quantity,timestamp) FROM '/home/project/sales.csv' delimiter ',' csv header;" 

 ## Delete sales.csv present in location /home/project

 ## Write your code here to load the DimDate table from the data present in sales_data table

 psql --username=postgres --host=localhost --dbname=sales_new -c  <replace with query used to populate the dimdate table>

## Write your code here to load the FactSales table from the data present in sales_data table

psql --username=postgres --host=localhost --dbname=sales_new -c  <replace with query used to populate the FactSales table>

 ## Write your code here to export DimDate table to a csv

 psql --username=postgres --host=localhost --dbname=sales_new -c <replace with command to export DimDate table to csv>

 ## Write your code here to export FactSales table to a csv
 
 psql --username=postgres --host=localhost --dbname=sales_new -c <replace with command to export FactSales table to csv>








#!/bin/bash

# MySQL database connection parameters
MYSQL_HOST="172.21.108.7"
MYSQL_USER="root"
MYSQL_PASS="uz1X5M79K60woCcNDGbsiEXj"
MYSQL_DB="sales"
MYSQL_TABLE="sales_data"
MYSQL_CSV="/tmp/sales_data.csv"

# PostgreSQL database connection parameters
PG_HOST="localhost"
PG_USER="postgres"
PG_PASS="MTE5MjktZG9uYWd5"
PG_DB="sales_new"
PG_TABLE="sales_data_staging"
PG_CSV="/tmp/sales_data.csv"

# Export data from MySQL to CSV
mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASS -e "SELECT * FROM $MYSQL_TABLE INTO OUTFILE '$MYSQL_CSV' FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\n';" $MYSQL_DB

# Check if the export was successful
if [ $? -eq 0 ]; then
    echo "Data exported successfully from MySQL to $MYSQL_CSV"
else
    echo "Error exporting data from MySQL"
    exit 1
fi

# Create the staging table in PostgreSQL if it doesn't exist
psql -h $PG_HOST -U $PG_USER -d $PG_DB -c "
CREATE TABLE IF NOT EXISTS $PG_TABLE (
    product_id INT,
    customer_id INT,
    price DECIMAL(10, 2),
    quantity INT,
    timestamp TIMESTAMP
);"

# Import data from CSV to PostgreSQL
psql -h $PG_HOST -U $PG_USER -d $PG_DB -c "\COPY $PG_TABLE FROM '$PG_CSV' WITH (FORMAT CSV, HEADER TRUE);"

# Check if the import was successful
if [ $? -eq 0 ]; then
    echo "Data imported successfully into PostgreSQL"
else
    echo "Error importing data into PostgreSQL"
    exit 1
fi

# Clean up
rm $MYSQL_CSV
