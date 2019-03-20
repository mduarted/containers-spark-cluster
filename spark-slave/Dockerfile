FROM spark-base:2.7.0
ENV SPARK_MASTER_HOST "spark://spark-master:7077"
COPY spark-slave.sh /

RUN chmod +x spark-slave.sh

CMD ["/bin/bash", "/spark-slave.sh"]
