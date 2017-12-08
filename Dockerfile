#specifying our base docker-image
#image based on https://www.anchormen.nl/spark-docker/
FROM ubuntu:latest
 
####installing [software-properties-common] so that we can use [apt-add-repository] to add the repository [ppa:webupd8team/java] form which we install Java8
RUN apt-get update && apt-get install -y \
	openjdk-8-jdk net-tools curl \
	ssh rsync openssh-server 

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

#####################################################################################
####downloading and unpacking Spark 2.1.0 [prebuilt for Hadoop 2.7+ and scala 2.10]
RUN wget http://mirror.switch.ch/mirror/apache/dist/spark/spark-2.2.0/spark-2.2.0-bin-hadoop2.7.tgz
RUN tar -xzf spark-2.2.0-bin-hadoop2.7.tgz
RUN mv spark-2.2.0-bin-hadoop2.7 /opt/spark
 
####exposing port 8080 so we can later access the Spark master UI; to verify spark is running …etc.
EXPOSE 8080
#####################################################################################

#####################################################################################
####installing supervisor
RUN apt-get install -y supervisor
 
COPY master.conf /opt/conf/master.conf
COPY slave.conf /opt/conf/slave.conf

# Some files to register as tables
RUN mkdir /data
COPY data/* /data/

COPY start-thrift.sh /

# this is to try make the the temporary tables created in spark visible in thriftServer 
RUN cp /opt/spark/conf/spark-defaults.conf.template /opt/spark/conf/spark-defaults.conf
RUN  echo 'spark.sql.hive.thriftServer.singleSession true' > /opt/spark/conf/spark-defaults.conf
#default command: running an interactive spark shell in the local mode
CMD ["/opt/spark/bin/spark-shell", "--master", "local[*]"]
