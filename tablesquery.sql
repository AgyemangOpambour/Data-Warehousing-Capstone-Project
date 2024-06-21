
-- create sales table
CREATE TABLE IF NOT EXISTS sales_data (
    product_id INT NOT NULL,
    customer_id INT NOT NULL,
    price INT NOT NULL,
    quantity INT NOT NULL,
    timestamp TIMESTAMP NOT NULL,
    PRIMARY KEY (product_id)
);

---- load csv files froma directory
LOAD DATA INFILE '/path/to/oltpdata.csv'
INTO TABLE sales_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


--- show all tables 
use sales;
show TABLES;

----- count all rows in sales table
SELECT COUNT(*) FROM sales_data;


---- create index ts on timestamp
CREATE INDEX ts ON sales_data (timestamp);
