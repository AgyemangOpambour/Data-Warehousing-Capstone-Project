from airflow import DAG
from airflow.providers.mysql.operators.mysql import MySqlOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.providers.mysql.hooks.mysql import MySqlHook
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.operators.python import PythonOperator
from airflow.utils.dates import days_ago
import pandas as pd

default_args = {
    'owner': 'airflow',
    'retries': 1,
}

def extract_from_mysql(**kwargs):
    mysql_hook = MySqlHook(mysql_conn_id='mysql_conn_id')
    sql = "SELECT * FROM sales_data"
    df = mysql_hook.get_pandas_df(sql)
    df.to_csv('/tmp/sales_data.csv', index=False)

def load_to_postgres(**kwargs):
    postgres_hook = PostgresHook(postgres_conn_id='postgres_conn_id')
    df = pd.read_csv('/tmp/sales_data.csv')
    df.to_sql('sales_data_staging', postgres_hook.get_sqlalchemy_engine(), if_exists='replace', index=False)

def transform_and_load_fact(**kwargs):
    postgres_hook = PostgresHook(postgres_conn_id='postgres_conn_id')
    transform_sql = """
    INSERT INTO FactSales (product_id, customer_id, total_price, quantity, sale_date)
    SELECT 
        product_id, 
        customer_id, 
        price * quantity AS total_price, 
        quantity, 
        DATE(timestamp) AS sale_date
    FROM sales_data_staging;
    """
    postgres_hook.run(transform_sql)

with DAG(
    'etl_dag',
    default_args=default_args,
    description='ETL process from MySQL to PostgreSQL',
    schedule_interval='@daily',
    start_date=days_ago(1),
    catchup=False,
) as dag:

    create_staging_table = PostgresOperator(
        task_id='create_staging_table',
        postgres_conn_id='postgres_conn_id',
        sql="""
        CREATE TABLE IF NOT EXISTS sales_data_staging (
            product_id INT,
            customer_id INT,
            price DECIMAL(10, 2),
            quantity INT,
            timestamp TIMESTAMP
        );
        """
    )

    create_fact_table = PostgresOperator(
        task_id='create_fact_table',
        postgres_conn_id='postgres_conn_id',
        sql="""
        CREATE TABLE IF NOT EXISTS FactSales (
            product_id INT,
            customer_id INT,
            total_price DECIMAL(10, 2),
            quantity INT,
            sale_date DATE
        );
        """
    )

    extract_data = PythonOperator(
        task_id='extract_data',
        python_callable=extract_from_mysql,
    )

    load_staging = PythonOperator(
        task_id='load_staging',
        python_callable=load_to_postgres,
    )

    transform_load_fact = PythonOperator(
        task_id='transform_load_fact',
        python_callable=transform_and_load_fact,
    )

    [create_staging_table, create_fact_table] >> extract_data >> load_staging >> transform_load_fact
