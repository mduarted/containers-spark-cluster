FROM openjdk:8-alpine

LABEL manteiner="Matheus Dias <matheusdias0211@gmail.com>"

ARG SPARK_VERSION=2.4.4
ARG HADOOP_VERSION=2.7

ENV SPARK_HOME="/spark"

RUN apk update && \
    apk add curl && \
    apk add bash && \
    apk add --no-cache python3 && \
    python3 -m ensurepip && \
    pip3 install --upgrade pip setuptools && \
    rm -r /usr/lib/python*/ensurepip && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache


RUN curl -o spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz http://www-us.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    tar xvf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} spark && \
    rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz

RUN adduser --shell /bin/bash --home /home/spark --disabled-password spark

RUN mkdir /spark-data/ && \
    chown spark:spark -R /spark/ && \
    chown spark:spark -R /home/spark

USER spark
