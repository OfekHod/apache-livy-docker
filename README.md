# apache-livy-docker
Apache Livy server for Docker with Spark dependencies.  
Tested on Spark Standalone version 2.4.6 and Livy version 0.7.0.  

## How to Run
1. Make sure you have Spark and Livy archives in this directory, you can download the latest supported versions in this repo by running `./download_archives.sh`.  
2. Build the image:
~~~
docker build . -t livy-ofekhod
~~~
3. Run container:  
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
livy-ofekhod
~~~  

If you need to support batch jobs, add another Docker volume for the jars path:  
~~~
docker run -d \
--name livy \
...
...
-e JARS_FOLDER=/opt/jars \
-v <jars-path>:/opt/jars
~~~  

For example (with batch job support):  
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
