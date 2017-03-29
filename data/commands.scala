val df = spark.read.csv("data/test.csv")
df.createOrReplaceTempView("test_csv")
val sqlDF = spark.sql("SELECT * FROM test_csv")
sqlDF.show()
