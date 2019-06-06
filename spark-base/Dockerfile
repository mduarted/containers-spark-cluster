FROM openjdk:8

LABEL manteiner="Matheus Dias <matheusdias0211@gmail.com>"

RUN apt-get update

RUN wget http://www-us.apache.org/dist/spark/spark-2.4.3/spark-2.4.3-bin-hadoop2.7.tgz
RUN tar xvf spark-2.4.0-bin-hadoop2.7.tgz
RUN mv spark-2.4.3-bin-hadoop2.7 spark
RUN rm spark-2.4.3-bin-hadoop2.7.tgz
RUN mkdir /spark-data/
RUN useradd -m spark -u 1000 -s /bin/bash -d /home/spark
RUN chown spark:spark -R /spark/
RUN chown spark:spark -R /home/spark
USER spark
