ARG SPARK_VERSION=2.4.4

FROM spark-base:${SPARK_VERSION}

COPY spark-master.sh /home/spark/

USER root
RUN chmod +x /home/spark/spark-master.sh

USER spark
CMD ["/bin/bash", "/home/spark/spark-master.sh"]
