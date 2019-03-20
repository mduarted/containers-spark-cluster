FROM debian:latest

LABEL manteiner="Matheus Dias <matheusdias0211@gmail.com>"

RUN apt-get update
RUN apt-get --assume-yes install software-properties-common
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
RUN apt-get --assume-yes install gnupg
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys  C2518248EEA14886
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update 
RUN apt-get --assume-yes install openjdk-7-jdk

RUN wget http://www-us.apache.org/dist/spark/spark-2.3.3/spark-2.3.3-bin-hadoop2.7.tgz
RUN tar xvf spark-2.3.3-bin-hadoop2.7.tgz
RUN mv spark-2.3.3-bin-hadoop2.7 spark
RUN rm spark-2.3.3-bin-hadoop2.7.tgz
RUN mkdir /spark-data/
