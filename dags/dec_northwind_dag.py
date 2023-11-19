import datetime
import pendulum
from textwrap import dedent

from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python_operator import PythonOperator
from airflow.providers.airbyte.operators.airbyte import AirbyteTriggerSyncOperator
from airflow.contrib.operators.slack_webhook_operator import SlackWebhookOperator
from airflow.hooks.base_hook import BaseHook

### Slack Alerts #####

SLACK_CONN_ID='slack_conn_mc'

def task_fail_slack_alert(context):
    slack_webhook_token = BaseHook.get_connection(SLACK_CONN_ID).password
    slack_msg = """
            :red_circle: Task Failed. 
            *Task*: {task}  
            *Dag*: {dag} 
            *Execution Time*: {exec_date}  
            *Log Url*: {log_url} 
            """.format(
            task=context.get('task_instance').task_id,
            dag=context.get('task_instance').dag_id,
            ti=context.get('task_instance'),
            exec_date=context.get('execution_date'),
            log_url=context.get('task_instance').log_url,
        )
    failed_alert = SlackWebhookOperator(
        task_id='slack_test',
        http_conn_id='slack_conn_mc',
        webhook_token=slack_webhook_token,
        message=slack_msg,
        channel="#airflow-notification-mc")
    return failed_alert.execute(context=context)

default_args = {
    'owner': 'airflow',
    'retries': 0,
    'on_failure_callback': task_fail_slack_alert
}

dag = DAG(
        dag_id='northwind_etl',
        schedule_interval='0 0 * * *',
        start_date=pendulum.datetime(2023, 11, 17, tz="America/Toronto"),
        catchup=False,
        render_template_as_native_obj=True,
        dagrun_timeout=datetime.timedelta(minutes=20),
        tags=['northwind'],
) 

with dag:

    data_interval_end = "{{ data_interval_end.format('YYYYMMDDHHmmss') }}"

    etl_start = SlackWebhookOperator(
        task_id="etl_start",
        http_conn_id="slack_conn_mc",
        message="ELT started",
        channel="#airflow-notification-mc"
    )

    trigger_sync = AirbyteTriggerSyncOperator(
         task_id='trigger_sync',
        airbyte_conn_id='airbyte_conn_mc',
        connection_id='5e2ff6b0-475b-44aa-b2b6-e384e950ffaa',
        asynchronous=False,
        timeout=900,
        wait_seconds=3
    )

    dbt_version = BashOperator(
        task_id="dbt_version",
        bash_command="/usr/local/airflow/dbt_env/bin/dbt --version"
    )

    dbt_env_json = "{{ var.json.DBT_ENV }}"

    dbt_build = BashOperator(
        task_id="dbt_build",
        env=dbt_env_json,
        bash_command="cp -R /opt/airflow/dags/dbt /tmp;\
    cd /tmp/dbt/northwind;\
    /usr/local/airflow/dbt_env/bin/dbt deps;\
    /usr/local/airflow/dbt_env/bin/dbt build --project-dir /tmp/dbt/northwind/ --profiles-dir . --target prod;"
    )

    etl_start >> trigger_sync >> dbt_version >> dbt_build 
