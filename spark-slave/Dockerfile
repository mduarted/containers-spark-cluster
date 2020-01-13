ARG SPARK_VERSION=2.4.4

FROM spark-base:${SPARK_VERSION}

ENV SPARK_MASTER_HOST "spark://spark-master:7077"
ENV SPARK_EXECUTION_CORES "1"
ENV SPARK_EXECUTION_MEM "2G"
COPY spark-slave.sh /home/spark/

USER root
RUN chmod +x /home/spark/spark-slave.sh

USER spark
CMD ["/bin/bash", "/home/spark/spark-slave.sh"]
