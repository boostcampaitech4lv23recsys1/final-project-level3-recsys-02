from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'RecSys-02',
    'depends_on_past': False,  # 이전 DAG의 Task가 성공, 실패 여부에 따라 현재 DAG 실행 여부가 결정. False는 과거의 실행 결과 상관없이 매일 실행한다
    'start_date': datetime(2023, 2, 1),
    'retires': 1,  # 실패시 재시도 횟수
    'retry_delay': timedelta(minutes=5)  # 만약 실패하면 5분 뒤 재실행
    # 'priority_weight': 10 # DAG의 우선 순위를 설정할 수 있음
    # 'end_date': datetime(2022, 4, 24) # DAG을 마지막으로 실행할 Date
    # 'execution_timeout': timedelta(seconds=300), # 실행 타임아웃 : 300초 넘게 실행되면 종료
    # 'on_failure_callback': some_function # 만약에 Task들이 실패하면 실행할 함수
    # 'on_success_callback': some_other_function
    # 'on_retry_callback': another_function
}

# with 구문으로 DAG 정의
with DAG(
        dag_id='Train',
        default_args=default_args,
        schedule_interval='0 15 * * *',
        tags=['RecSys-02-Dags']
) as dag:
    # BashOperator 사용
    train = BashOperator(
        task_id='Train',  # task의 id
        bash_command='python /opt/ml/git/final-project-level3-recsys-02/bentoml/run_finetune_full.py'  # 실행할 bash command
    )

    shell = BashOperator(
        task_id='Shell',
        bash_command='cd /opt/ml/git/final-project-level3-recsys-02/bentoml && poetry shell',
    )

    pakage = BashOperator(
        task_id='Pakage',
        bash_command='python /opt/ml/git/final-project-level3-recsys-02/bentoml/my_bento_packer.py',
    )

    termination = BashOperator(
        task_id='Termination',
        bash_command='pkill -9 bentoml'
    ) 

    server = BashOperator(
        task_id='Server',
        bash_command='bentoml serve --port 30001 MyService:latest',
        depends_on_past=False
    )

    train >> shell >> pakage >> termination >> server
