# containers-spark-cluster

Building a cluster of Apache Spark with containers using Docker-compose

## Requirements

1) [docker](https://docs.docker.com/install/) on your machine.
2) [docker-compose](https://docs.docker.com/compose/install/) on you machine.

## Setting up variables
Before we start building, we need to define some variables.

```bash
export SPARK_VERSION=2.4.4 #Here we are defining the Spark version to create our cluster. The default value is 2.4.4
export HADOOP_VERSION=2.7 #Here we are defining the Hadoop version to support our Spark cluster. The default value is 2.7
```

## Building the Base Image

The base image, named as spark-base, has all the dependencies that Spark needs to start.

To build this image you need to execute the following code on project root folder:

```bash
docker build -t=spark-base:$SPARK_VERSION --build-arg SPARK_VERSION=$SPARK_VERSION --build-arg HADOOP_VERSION=$HADOOP_VERSION ./spark-base/
```

Good! Now you have the spark-base image completed, note that the version of spark-base image is the version of Spark that is installed inside then.

## Building the Master Node Image

The master image, named as spark-master, is the image that represents our master node on the cluster. Note that we build this image using the spark-base image (where we have all the dependencies). The Dockerfile of this image only copy a .sh file (spark-master.sh) into the image and execute then when image's up is completed. This .sh file will start the spark node as a master node with the following code:

```bash
/spark/bin/spark-class org.apache.spark.deploy.master.Master -h $SPARK_MASTER_HOST
```
Note that SPARK_MASTER_HOST variable is defined on this .sh file by hostname command that get the host name and domain name defined on docker-compose.yaml file, that we will see later.

To build this image you need to execute the following code on project root folder:
```bash
docker build -t=spark-master:$SPARK_VERSION --build-arg SPARK_VERSION=$SPARK_VERSION ./spark-master/
```

Nice! Now we have the master image completed and ready to up.

## Building the Slave Node Image

The slave image, named as spark-slave, is the image that represents our slave nodes (or worker nodes) on the cluster. This image it's like the spark-master image, but we start the node as a Worker in the .sh file (spark-slave.sh). The following is the code to run Spark as Worker node:
```bash
/spark/bin/spark-class org.apache.spark.deploy.worker.Worker $SPARK_MASTER_HOST
```
Note that in Dockerfile we define SPARK_EXECUTION_CORES and SPARK_EXECUTION_MEM environment variables, this variables represent the cores and memory parameter to spark execution to each slave node. Follow the default values:
```bash
ENV SPARK_EXECUTION_CORES "1"
ENV SPARK_EXECUTION_MEM "2G"
```

To build this image you need to execute the following code on project folder:
```bash
docker build -t=spark-slave:$SPARK_VERSION --build-arg SPARK_VERSION=$SPARK_VERSION ./spark-slave/
```
Great! Now we have the spark-slave image ready to get up and get started as Worker node on Spark cluster.

## Explaining docker-compose.yaml file

At this point we have all the images needed to start our cluster correctly. And we will use the Docker Compose to do this for us.

We have the following docker-compose.yaml file to configure and up all the nodes.

```bash
version: "3.0"        # defining the version of docker-compose.yaml file format
        services:
                spark-master:                      # creating Spark Master node using spark-master image
                        image: spark-master:$SPARK_VERSION        
                        container_name: spark-master
                        hostname: spark-master        # defining the host name and domain name of this node
                        ports:                        # doing a port pointing from host to node (this allows us to connect to cluster using host IP)
                                - "8095:8080"         # 8080 is the port of UI of Spark Master node, and we can acces then using our 8095 localhost port
                                - "7077:7077"         # 7077 is the port to access the Master Node via spark-shell and submit your applications to the cluster.    
                        networks:                     # setting the network used.
                                spark-network:
                                        ipv4_address: 10.15.0.2   # defining a static ipv4 address respecting the subnet rule defined to this network
                spark-slave-1:                        # creating slave01.
                         image: spark-slave:$SPARK_VERSION
                         depends_on:
                                 - spark-master
                         container_name: spark-slave-1
                         hostname: spark-slave-1
                         volumes:
                                - /spark-data:/spark-data     # creating this volume to read host files in this volume inside cluster.
                         networks:
                                 spark-network:
                                         ipv4_address: 10.15.0.3
                spark-slave-2:                       # creating slave02.
                         image: spark-slave:$SPARK_VERSION
                         depends_on:
                                 - spark-master
                         container_name: spark-slave-2
                         hostname: spark-slave-2
                         volumes:
                                - /spark-data:/spark-data
                         networks:
                                 spark-network:
                                         ipv4_address: 10.15.0.4
                spark-slave-3:                       # creating slave01.
                         image: spark-slave:$SPARK_VERSION
                         depends_on:
                                 - spark-master
                         container_name: spark-slave-3
                         hostname: spark-slave-3
                         networks:
                                 spark-network:
                                         ipv4_address: 10.15.0.5
        networks:
                spark-network:                      # creating a network.
                        driver: bridge              # defining drives as "bridge" where is created a private network between host and containers. If your spark application is running in other container then you need to use this network to connect to cluster. Example: docker run [OPTIONS] --network="cluster_spark_spark-network" [IMAGE]
                        ipam:
                                driver: default
                                config:
                                        - subnet: 10.15.0.0/16    # defining a subnet to this network
```

## Creating volumes

We need to create our volumes too, run the following code to create the "spark-data" volume:

```bash
sudo mkdir /spark-data/
sudo chown $(whoami):$(whoami) /spark-data/
```

Volumes created!

## Running Docker-compose

And now, to run our docker-compose we need to execute the following code on project root folder:

```bash
docker-compose up
```

Now we have our spark cluster up and running! 
Our master URL of cluster in spark://localhost:7077 (this master url is used to connect applications to cluster via driver or spark-submit). 
Our Cluster UI are listening on port 8095 (http://localhost:8095).
