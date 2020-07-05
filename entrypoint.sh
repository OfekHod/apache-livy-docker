#!/bin/bash

# Expecting arguemnts (LIVY_HOME, SPARK_HOME)
LIVY_HOME=$1
SPARK_HOME=$2

mkdir $LIVY_HOME/logs

# Create `livy-env.sh` file
echo '#!/bin/bash' >> $LIVY_HOME/conf/livy-env.sh
echo 'export SPARK_HOME='$SPARK_HOME >> $LIVY_HOME/conf/livy-env.sh 

# Create `livy.conf` file
echo livy.spark.master = spark://$SPARK_MASTER_ENDPOINT:$SPARK_MASTER_PORT >> $LIVY_HOME/conf/livy.conf
echo livy.file.local-dir-whitelist = $LIVY_FILE_LOCAL_DIR_WHITELIST >> $LIVY_HOME/conf/livy.conf

$LIVY_HOME/bin/livy-server
