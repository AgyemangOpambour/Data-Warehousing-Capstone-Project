#!/bin/bash

# MySQL database connection parameters
DB_HOST="172.21.49.3"
DB_USER="root"
DB_PASS="7z2HX1XAEFzJqhNArb2CE6H5"
DB_NAME="sales"

# File name for SQL dump
OUTPUT_FILE="sales_data.sql"

echo "Starting data dump..."
mysqldump --host=$DB_HOST --user=$DB_USER --password="$DB_PASS" $DB_NAME sales_data > $OUTPUT_FILE 2>&1
echo "Finished data dump..."

# Check if mysqldump command executed successfully
if [ $? -eq 0 ]; then
    echo "Data dumped successfully to $OUTPUT_FILE"
else
    echo "Error: Failed to dump data to $OUTPUT_FILE"
fi

