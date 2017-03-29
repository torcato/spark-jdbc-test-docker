#specifying our base docker-image
#image based on https://www.anchormen.nl/spark-docker/
FROM ubuntu:14.04
 
####installing [software-properties-common] so that we can use [apt-add-repository] to add the repository [ppa:webupd8team/java] form which we install Java8
RUN apt-get update -y
RUN apt-get install software-properties-common -y
RUN apt-add-repository ppa:webupd8team/java -y
RUN apt-get update -y
 
####automatically agreeing on oracle license agreement that normally pops up while installing java8
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
 
####installing java
RUN apt-get install -y oracle-java8-installer

#####################################################################################
####downloading and unpacking Spark 2.1.0 [prebuilt for Hadoop 2.7+ and scala 2.10]
RUN wget http://d3kbcqa49mib13.cloudfront.net/spark-2.1.0-bin-hadoop2.7.tgz
RUN tar -xzf spark-2.1.0-bin-hadoop2.7.tgz
RUN mv spark-2.1.0-bin-hadoop2.7 /opt/spark
 
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
