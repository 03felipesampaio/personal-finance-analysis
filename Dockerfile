# Description: Dockerfile for dbt
FROM python:3.12
# Needed variables: 
    # DBT_PROJECT
    # DBT_DATASET
    # GOOGLE_APPLICATION_CREDENTIALS

WORKDIR /usr/app

RUN pip install --upgrade pip

RUN mkdir -p /root/.dbt

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY ./personal_finance_analysis /usr/app

# COPY entrypoint.sh /entrypoint.sh
# RUN chmod +x /entrypoint.sh

# Set some variables and files and then run "dbt" + arguments from CMD
# ENTRYPOINT ["/entrypoint.sh"]
ENTRYPOINT ["dbt"]
CMD ["run"]