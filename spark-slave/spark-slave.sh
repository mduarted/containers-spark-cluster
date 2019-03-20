#!/bin/bash

export SPARK_HOME="/spark"

/spark/bin/spark-class org.apache.spark.deploy.worker.Worker $SPARK_MASTER_HOST
