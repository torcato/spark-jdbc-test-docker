# spark-jdbc-test-docker

This is the Dockerfile and startup script to start a small spark cluster and frontent odbc/jdbc server.
It was used for testing raw using a spark-cluster as a data source using hive-jdbc.

The script will start docker 4 containers.
* a master node: port 8080 mapped to host machine to get the status of the spark cluster.
* a worker node.
* a thriftserver, the jdbc server for spark: port 10000 mapped to host machine for jdbc connection.
* and a spark shell so that we can create some data (optional).

## Usage
run the start.sh script to build and start the docker containers.
To test the jdbc connection you can use any jdbc client bellow an example using Squirrel SQL.

### Squirrel SQL instructions:
Add a new driver in squirrel
**Example URL:** jdbc:hive2://localhost:10000

**Class Name:** org.apache.hive.jdbc.HiveDriver

This driver has quite a lot of dependencies so in the "Extra Class Path" tab I selected all the jars in the \<spark path>/jars folder.

create a new connection to using the default url in your host machine and that's it!
