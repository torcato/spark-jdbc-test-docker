docker build -t anchormen/spark . 
#creates the network for the spark nodes
docker network create spark-network

#The master node
docker run -d --net spark-network --name master -p 8080:8080 anchormen/spark /usr/bin/supervisord --configuration=/opt/conf/master.conf

# running a slave node
docker run -d --net spark-network anchormen/spark /usr/bin/supervisord --configuration=/opt/conf/slave.conf

#start Thrift Server to be able to use jdbc
docker run -d --net spark-network -p 10000:10000 --cpuset-cpus="0" anchormen/spark /start-thrift.sh --master spark://master:7077

#running a shell
docker run -it --net spark-network anchormen/spark /opt/spark/bin/spark-shell --master spark://master:7077
