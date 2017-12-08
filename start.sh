image="dias/spark-jdbc-test"

docker build -t $image . 
#creates the network for the spark nodes
docker network create spark-network

#The master node
docker run -d --net spark-network --name master -p 8080:8080 $image /usr/bin/supervisord --configuration=/opt/conf/master.conf

# running a slave node
docker run -d --net spark-network $image /usr/bin/supervisord --configuration=/opt/conf/slave.conf

#start Thrift Server to be able to use jdbc
docker run -d --net spark-network -p 10000:10000 --cpuset-cpus="0" $image /start-thrift.sh --master spark://master:7077

#running a shell
docker run -it --net spark-network $image /opt/spark/bin/spark-shell --master spark://master:7077
