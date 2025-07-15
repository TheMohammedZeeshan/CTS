from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime

default_args = {
    'start_date': datetime(2023, 1, 1),
}

with DAG(
    dag_id='run_dbt_models',
    schedule_interval='0 */2 1-7 * 1',
    default_args=default_args,
    catchup=False,
    tags=['clinicaltrials'],
) as dag:

    ingest_data = BashOperator(
        task_id='ingest_data',
        bash_command="""
        /home/reach2zeeshan/clinicaltrials/venv/bin/python /home/reach2zeeshan/clinicaltrials/ingestion/data_ingestion.py
        """
    )

    dbt_run = BashOperator(
        task_id='dbt_run',
        bash_command="""
        cd /home/reach2zeeshan/clinicaltrials &&
        /home/reach2zeeshan/clinicaltrials/venv/bin/dbt run
        """
    )

    dbt_test = BashOperator(
        task_id='dbt_test',
        bash_command="""
        cd /home/reach2zeeshan/clinicaltrials &&
        /home/reach2zeeshan/clinicaltrials/venv/bin/dbt test
        """
    )

    ingest_data >> dbt_run >> dbt_test
