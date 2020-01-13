#!/bin/bash

export SPARK_MASTER_HOST=`hostname`

/spark/bin/spark-class org.apache.spark.deploy.master.Master -h $SPARK_MASTER_HOST
