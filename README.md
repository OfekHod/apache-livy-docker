# apache-livy-docker
Apache Livy server for Docker with Spark dependencies.  
Tested on Spark Standalone version 2.4.6 and Livy version 0.7.0.  

## Build & Run
1. Make sure you have Spark and Livy archives in this directory, you can download the latest supported versions in this repo by running:  
~~~
./download_archives.sh
~~~
2. Build Livy image:
~~~
docker build . -t livy-ofekhod
~~~
3. Run a container:  
~~~
docker run -d \
--name livy \
-e SPARK_MASTER_ENDPOINT=<spark-master-url> \
-e SPARK_MASTER_PORT=<spark-master-port> \
-p 8998:8998 \
-p 7077:7077 \
livy-ofekhod
~~~  

For example:  
~~~
docker run -d \
--name livy \
-e SPARK_MASTER_ENDPOINT=spark \
-e SPARK_MASTER_PORT=7077 \
-p 8998:8998 \
-p 7077:7077 \
livy-ofekhod
~~~  
4. Access Livy's UI via `http://localhost:8998`  

### Support Batch Jobs
If you need to support batch jobs, add a Docker volume for the jars path and a corresponding local directory whitelist path for Livy (`livy.file.local-dir-whitelist`):  
~~~
docker run -d \
--name livy \
...
...
-e LIVY_FILE_LOCAL_DIR_WHITELIST=/opt/jars \
-v <jars-path>:/opt/jars \
...
livy-ofekhod
~~~  

For example:  
~~~
docker run -d \
--name livy \
-e SPARK_MASTER_ENDPOINT=spark \
-e SPARK_MASTER_PORT=7077 \
-e LIVY_FILE_LOCAL_DIR_WHITELIST=/opt/jars \
-v $PWD/jars:/opt/jars \
-p 8998:8998 \
-p 7077:7077 \
livy-ofekhod
~~~  
   
### Extra Parameters To livy.conf
If you need to add extra parameters to `livy.conf`, please add them to `livy.conf.extra`.  
  
Note that parameters from env (-e in `docker run`) overrides parameters from `livy.conf.extra`.  
Supported parameters from env are:  
~~~
SPARK_MASTER_ENDPOINT
SPARK_MASTER_PORT
LIVY_FILE_LOCAL_DIR_WHITELIST
~~~  
Both `SPARK_MASTER_ENDPOINT` and `SPARK_MASTER_PORT` should be provided in order to compound `livy.spark.master`, otherwise it will be taken from `livy.conf.extra`

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
-e SPARK_MASTER_ENDPOINT=spark \
-e SPARK_MASTER_PORT=7077 \
-e LIVY_FILE_LOCAL_DIR_WHITELIST=/opt/jars \
-v $PWD/jars:/opt/jars \
-p 8998:8998 \
livy-ofekhod
~~~
  
## Use Other Spark Version  
In order to use another Spark version:  
1. Download relevant (Spark archive)[https://archive.apache.org/dist/spark/] (change `download_archives.sh`).  
2. Edit `Dockerfile`'s SPARK_VERSION (possibly HADOOP_VERSION as well).  

## Use Other Livy Version
In order to use another Livy version:  
1. Download (Livy archive)[http://mirror.23media.de/apache/incubator/livy/] (change `download_archives.sh`).  
2. Edit `Dockerfile`'s LIVY_VERSION.  
