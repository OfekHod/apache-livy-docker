#!/bin/bash

# Create directories
mkdir $LIVY_HOME/logs

# Create `livy.conf` file
echo livy.spark.master = spark://$SPARK_MASTER_ENDPOINT:$SPARK_MASTER_PORT >> $LIVY_HOME/conf/livy.conf
echo livy.file.local-dir-whitelist = $LIVY_FILE_LOCAL_DIR_WHITELIST >> $LIVY_HOME/conf/livy.conf

$LIVY_HOME/bin/livy-server
