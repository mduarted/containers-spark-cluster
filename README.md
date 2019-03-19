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

Good! Now you have the spark-base image complete, note that the version of spark-base image is the version of Spark that is installed inside then.

## Building the Master Node Image

The master image, named as spark-master, is the image that represents our master node on the cluster. Note that we build this image using the spark-base image (where we have all the dependencies). The Dockerfile of this image only copy a .sh file (spark-master.sh) into the image and execute then when image's up is completed. This .sh file will start the spark node as a master node with the following code:

```bash
/spark/bin/spark-class org.apache.spark.deploy.master.Master -h $SPARK_MASTER_HOST
```
Note that SPARK_MASTER_HOST variable is defined on this .sh file by hostname command that get the host name and domain name defined on docker-compose.yaml file, that we will see later.

To build this image you need to execute the following code on project folder:
```bash
docker build -t=spark-master:2.3.3 ./spark-master/
```

Nice! Now we have the master image complete and ready to up.

## Building the Slave Node Image

The slave image, named as spark-slave, is the image that represents our slave nodes (or worker nodes) on the cluster. This image it's like the spark-master image, but we start the node as a Worker in the .sh file (spark-slave.sh). The following is the code to run Spark as Worker node:
```bash
/spark/bin/spark-class org.apache.spark.deploy.worker.Worker $SPARK_MASTER_HOST
```

To build this image you need to execute the following code on project folder:
```bash
docker build -t=spark-slave:2.3.3 ./spark-slave/
```
Great! Now we have the spark-slave image ready to get up and get started as Worker node on Spark cluster.

## Explaining docker-compose.yaml file

At this point we have all the images needed to start our cluster correctly. And we will use the Docker Compose to do this for us.

We have the following docker-compose.yaml file to configure and up all the nodes.

```bash
version: "3.0"        # Defines the version of docker-compose.yaml file format
        services:
                spark-master:                      # Here we are creating our Spark Master node using our spark-master image
                        image: spark-master:2.3.3        
                        container_name: spark-master
                        hostname: spark-master        # Here we are defining the host name and domain name of this node
                        ports:                        # Here we are doing a port pointing from host to node (this allows us to connect to cluster using host IP)
                                - "8095:8080"         # 8080 is the port of UI of Spark Master node, and we can acces then using our 8095 localhost port
                                - "7077:7077"         # 7077 is the port to access the Master Node via spark-shell and submit your applications to the cluster.
                        networks:                     # I will talk more about this network later.
                                spark-network:
                                        ipv4_address: 172.18.0.2
                spark-slave-1:
                         image: spark-slave:2.3.3
                         depends_on:
                                 - spark-master
                         container_name: spark-slave-1
                         hostname: spark-slave-1
                         networks:
                                 spark-network:
                                         ipv4_address: 172.18.0.3
                spark-slave-2:
                         image: spark-slave:2.3.3
                         depends_on:
                                 - spark-master
                         container_name: spark-slave-2
                         hostname: spark-slave-2
                         networks:
                                 spark-network:
                                         ipv4_address: 172.18.0.4
                spark-slave-3:
                         image: spark-slave:2.3.3
                         depends_on:
                                 - spark-master
                         container_name: spark-slave-3
                         hostname: spark-slave-3
                         networks:
                                 spark-network:
                                         ipv4_address: 172.18.0.5
        networks:
                spark-network:
                        driver: bridge
                        ipam:
                                driver: default
                                config:
                                        - subnet: 172.18.0.0/16
```


