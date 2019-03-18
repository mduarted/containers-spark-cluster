# containers-spark-cluster

Building a cluster of Apache Spark with containers using Docker-compose

## Requirements

1) You need to have [docker](https://docs.docker.com/install/) on your machine.
2) You need to have [docker-compose](https://docs.docker.com/compose/install/) on you machine.

## Building the Base Image

The base image, named as spark-base, have all the dependencies that Spark needs to start.

To build this image you need to execute the following code on project root folder:

```bash
docker build -t=spark-base:2.3.3 ./spark-base/
```

Nice! Now you have the spark-base image complete, note that the version of spark-base image is the version of Spark that is installed inside the image.

## Building the Master Node Image

The master image, named as spark-master, is the image that will represent our master node on the cluster. Note that we build this image using the spark-base image (where we have all the dependencies). The Dockerfile of this image only copy a .sh file into the image and execute then when image's up is completed. This .sh file, named as spark-master.sh, will start the spark node as a master node with the following code:

```bash
/spark/bin/spark-class org.apache.spark.deploy.master.Master -h $SPARK_MASTER_HOST
```
Note that SPARK_MASTER_HOST is defined on this .sh file by hostname command that get the host name and domain name defined on docker-compose.yaml file, that we will later.

To build this image you need to execute the following code on project folder:
```bash
docker build -t=spark-master:2.3.3 ./spark-master/
```

Good! Now we have the master image complete and ready to up.

## Building the Slave Node Image
