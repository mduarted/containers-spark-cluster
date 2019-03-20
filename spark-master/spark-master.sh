#!/bin/bash

export SPARK_MASTER_HOST=`hostname`
export SPARK_HOME="/spark"

/spark/bin/spark-class org.apache.spark.deploy.master.Master -h $SPARK_MASTER_HOST
