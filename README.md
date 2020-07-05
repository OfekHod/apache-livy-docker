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
  
Use `spark-standalone/bitnami/docker-compose.yml` in order to run Livy with Spark Standalone on your computer:  
~~~
docker-compose --file spark-standalone-support/bitnami/docker-compose.yml up -d
~~~

## Use Other Spark Version  
In order to use another Spark version:  
1. Download relevant [Spark archive](https://archive.apache.org/dist/spark/) (change `download_archives.sh`).  
2. Edit `Dockerfile`'s SPARK_VERSION (possibly HADOOP_VERSION as well).   
3. (If Spark Standalone): update `spark-standalone-support/bitnami/docker-compose.yml` to use the correct spark/bitnami images tags for the desired Spark version.

## Use Other Livy Version
In order to use another Livy version:  
1. Download [Livy archive](http://mirror.23media.de/apache/incubator/livy/) (change `download_archives.sh`).  
2. Edit `Dockerfile`'s LIVY_VERSION.  
