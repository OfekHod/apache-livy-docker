# apache-livy-docker
Apache Livy server for Docker with Spark dependencies.  
Tested on Spark Standalone version 2.4.6 and Livy version 0.7.0.  

## Build & Run
1. Make sure you have Spark and Livy archives in this directory, you can download the latest supported versions in this repo by running `./download_archives.sh`.  
2. Build Livy image:
~~~
docker build . -t livy-ofekhod
~~~
3. Run a container:  
~~~
docker run -d \
--name livy \
-e SPARK_HOME=/opt/spark-2.4.6-bin-hadoop2.7 \
-e SPARK_MASTER_ENDPOINT=<spark-master-url> \
-e SPARK_MASTER_PORT=<spark-master-port> \
-e LIVY_HOME=/opt/apache-livy-0.7.0-incubating-bin \
-e LIVY_FILE_LOCAL_DIR_WHITELIST=/ \
-p 8998:8998 \
-p 7077:7077 \
livy-ofekhod
~~~  

If you need to support batch jobs, add a Docker volume for the jars path:  
~~~
docker run -d \
--name livy \
...
...
-e JARS_FOLDER=/opt/jars \
-v <jars-path>:/opt/jars \
...
livy-ofekhod
~~~  

For example (with batch jobs support):  
~~~
docker run -d \
--name livy \
-e SPARK_HOME=/opt/spark-2.4.6-bin-hadoop2.7 \
-e SPARK_MASTER_ENDPOINT=spark \
-e SPARK_MASTER_PORT=7077 \
-e LIVY_HOME=/opt/apache-livy-0.7.0-incubating-bin \
-e LIVY_FILE_LOCAL_DIR_WHITELIST=/ \
-p 8998:8998 \
-p 7077:7077 \
-e JARS_FOLDER=/opt/jars \
-v /opt/spark-2.4.6-bin-hadoop2.7/examples/jars:/opt/jars \
livy-ofekhod
~~~  
4. Access Livy's UI via `http://localhost:8998`    
  
## Setup & Run with Spark Standalone (Bitnami)
Tested with [bitnami/Spark](https://hub.docker.com/r/bitnami/spark) version 2.4.6
1. Save `docker-compose.yml` of bitnami/spark:  
~~~
version: '2'

services:
  spark:
    image: docker.io/bitnami/spark:2.4.6
    environment:
      - SPARK_MODE=master
      - SPARK_RPC_AUTHENTICATION_ENABLED=no
      - SPARK_RPC_ENCRYPTION_ENABLED=no
      - SPARK_LOCAL_STORAGE_ENCRYPTION_ENABLED=no
      - SPARK_SSL_ENABLED=no
    ports:
      - "8080:8080"
      - "7077:7077"
  spark-worker-1:
    image: docker.io/bitnami/spark:2.4.6
    environment:
      - SPARK_MODE=worker
      - SPARK_MASTER_URL=spark://spark:7077
      - SPARK_WORKER_MEMORY=1G
      - SPARK_WORKER_CORES=1
      - SPARK_RPC_AUTHENTICATION_ENABLED=no
      - SPARK_RPC_ENCRYPTION_ENABLED=no
      - SPARK_LOCAL_STORAGE_ENCRYPTION_ENABLED=no
      - SPARK_SSL_ENABLED=no
  spark-worker-2:
    image: docker.io/bitnami/spark:2.4.6
    environment:
      - SPARK_MODE=worker
      - SPARK_MASTER_URL=spark://spark:7077
      - SPARK_WORKER_MEMORY=1G
      - SPARK_WORKER_CORES=1
      - SPARK_RPC_AUTHENTICATION_ENABLED=no
      - SPARK_RPC_ENCRYPTION_ENABLED=no
      - SPARK_LOCAL_STORAGE_ENCRYPTION_ENABLED=no
      - SPARK_SSL_ENABLED=no
~~~  
2. Start Spark with `docker-compose up &`  (Spark's UI now available at http://localhost:8080)  
3. Build Livy image:
~~~
docker build . -t livy-ofekhod
~~~  
4. Run a container, note that:  

* Assigned network `spark-standalone_default`- the same network as bitnami/spark.  
* Opened only Livy's UI port because Spark Master port 7077 is open due to shared containers network.  
* SPARK_MASTER_ENDPOINT is `spark` (bitnami/spark exposes it that way).  
~~~
docker run -d \
--name livy \
--network spark-standalone_default \
-e SPARK_HOME=/opt/spark-2.4.6-bin-hadoop2.7 \
-e SPARK_MASTER_ENDPOINT=spark \
-e SPARK_MASTER_PORT=7077 \
-e LIVY_HOME=/opt/apache-livy-0.7.0-incubating-bin \
-e LIVY_FILE_LOCAL_DIR_WHITELIST=/ \
-p 8998:8998 \
livy-ofekhod
~~~
  
## Use Other Spark Version  
In order to use another Spark version:  
1. Download Spark archive (change `download_archives.sh`).  
2. Edit `Dockerfile`'s SPARK_VERSION (possibly HADOOP_VERSION as well).  
3. When running the container (in `docker run` command), change `-e SPARK_HOME=/opt/spark-2.4.6-bin-hadoop2.7` to your current Spark version (and possibly Hadoop).  

## Use Other Livy Version
In order to use another Livy version:  
1. Download Livy archive (change `download_archives.sh`).  
2. Edit `Dockerfile`'s LIVY_VERSION.  
3. When running the container (in `docker run` command), change `-e LIVY_HOME=/opt/apache-livy-0.7.0-incubating-bin` to your current Livy version.    
