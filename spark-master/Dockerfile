FROM spark-base:2.4.3

COPY spark-master.sh /home/spark/

USER root
RUN chmod +x /home/spark/spark-master.sh

USER spark
CMD ["/bin/bash", "/home/spark/spark-master.sh"]
