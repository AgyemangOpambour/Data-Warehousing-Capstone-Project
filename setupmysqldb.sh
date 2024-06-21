#!/bin/sh

# This startup script does the following
# Creates a database sales
# Uses the sales database
# Creates a table sales_data with fields rowid,productid,customerid,price,quantity and timestamp.

# password MTE5MjktZG9uYWd5

# mysql --host=127.0.0.1 --port=3306 --user=root --password="MTE5MjktZG9uYWd5" -e "create database sales;
# use sales;drop table if exists sales_data;create table sales_data(rowid int DEFAULT NULL,product_id int DEFAULT NULL,
# customer_id int DEFAULT NULL,price decimal(10,0) DEFAULT NULL,
# quantity int DEFAULT NULL,timestamp timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP);"

# # Loading data from sales_olddata.csv into sales_data table.This csv consists of data with old timestamp.

# mysql --host=127.0.0.1 --port=3306 --user=root --password="MTE5MjktZG9uYWd5" -e "use sales;load data infile 'C:/Users/opambour/Downloads/Video/Final-Project-Capstone/Capstone-Project/week4/sales_olddata.csv' into table sales_data fields terminated BY ','lines terminated BY '\n';"

# # Loading data from sales_newdata.csv into sales_data table.This csv consists of data updated with the current timestamp.
# mysql --host=127.0.0.1 --port=3306 --user=root --password="MTE5MjktZG9uYWd5" -e "use sales;load data infile 'C:/Users/opambour/Downloads/Video/Final-Project-Capstone/Capstone-Project/week4/sales_newdata.csv' into table sales_data fields terminated BY ',' lines terminated BY '\n'(rowid,product_id,customer_id,price, quantity);"


#!/bin/bash

# MySQL database connection parameters
DB_HOST="127.0.0.1"
DB_PORT="3306"
DB_USER="root"
DB_PASS="MTE5MjktZG9uYWd5"
DB_NAME="sales"
DATA_FILE="C:/Users/opambour/Downloads/Video/Final-Project-Capstone/Capstone-Project/week4/sales_olddata.csv"

# Load data into the sales_data table
# mysql --host=$DB_HOST --port=$DB_PORT --user=$DB_USER --password=$DB_PASS -e "
#   USE $DB_NAME;
#   LOAD DATA INFILE '$DATA_FILE'
#   INTO TABLE sales_data
#   FIELDS TERMINATED BY ','
#   LINES TERMINATED BY '\n';
# "


export MYSQL_PWD='MTE5MjktZG9uYWd5'
mysql --host=$DB_HOST --port=$DB_PORT --user=$DB_USER -e "
  USE $DB_NAME;
  LOAD DATA INFILE '$DATA_FILE'
  INTO TABLE sales_data
  FIELDS TERMINATED BY ','
  LINES TERMINATED BY '\n';
"
unset MYSQL_PWD


