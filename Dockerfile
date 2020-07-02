FROM openjdk:11-jdk-slim-buster

RUN apt-get update
RUN apt-get install unzip
RUN apt-get -y install wget

ENV SPARK_VERSION=2.4.6
ENV HADOOP_VERSION=2.7
ENV LIVY_VERSION=0.7.0

# Assuming you already downloaded Spark to the current directory from https://archive.apache.org/dist/spark/spark-2.4.6/spark-2.4.6-bin-hadoop2.7
ENV SPARK_ARCHIVE=spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz

# Assuming you already downloaded Livy to the current directory from http://mirror.23media.de/apache/incubator/livy/0.7.0-incubating/apache-livy-0.7.0-incubating-bin.zip
ENV LIVY_ARCHIVE=apache-livy-${LIVY_VERSION}-incubating-bin.zip

ENV ARCHIVES_PATH=/tmp
ENV WORKDIR_PATH=/opt

COPY $SPARK_ARCHIVE $ARCHIVES_PATH
COPY $LIVY_ARCHIVE $ARCHIVES_PATH

RUN tar -xvzf $ARCHIVES_PATH/$SPARK_ARCHIVE -C $WORKDIR_PATH
RUN unzip $ARCHIVES_PATH/$LIVY_ARCHIVE -d $WORKDIR_PATH

RUN rm $ARCHIVES_PATH/$SPARK_ARCHIVE
RUN rm $ARCHIVES_PATH/$LIVY_ARCHIVE

COPY entrypoint.sh $WORKDIR_PATH
RUN chmod +x $WORKDIR_PATH/entrypoint.sh

WORKDIR $WORKDIR_PATH
ENTRYPOINT ./entrypoint.sh
