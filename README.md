# spark-jdbc-test-docker

This is the Dockerfile and startup script used for testing raw using a spark-cluster as a data source.

The script will start docker 4 instances.
* a master node 
* a slave node
* a thriftserver (the jdbc server for spark)
* and a spark shell so that we can create some data (optional)
