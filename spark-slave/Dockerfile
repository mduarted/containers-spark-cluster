FROM spark-base:2.3.3
ENV SPARK_MASTER_HOST "spark://spark-master:7077"
COPY spark-slave.sh /home/spark/

USER root
RUN chmod +x /home/spark/spark-slave.sh

USER spark
CMD ["/bin/bash", "/home/spark/spark-slave.sh"]
