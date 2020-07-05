#!/bin/bash

# Create directories
mkdir $LIVY_HOME/logs

# Create `livy-env.sh` file
echo '#!/bin/bash' >> $LIVY_HOME/conf/livy-env.sh
echo 'export SPARK_HOME=/opt/spark-2.4.6-bin-hadoop2.7' >> $LIVY_HOME/conf/livy-env.sh 

# Create `livy.conf` file
echo livy.spark.master = spark://$SPARK_MASTER_ENDPOINT:$SPARK_MASTER_PORT >> $LIVY_HOME/conf/livy.conf
echo livy.file.local-dir-whitelist = $LIVY_FILE_LOCAL_DIR_WHITELIST >> $LIVY_HOME/conf/livy.conf

$LIVY_HOME/bin/livy-server
