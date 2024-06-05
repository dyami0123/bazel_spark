import delta
import mimesis
import pyspark

try:
    # FIXME: this is bad practice, remove this
    from aws_keys import aws_access_key_id, aws_secret_access_key
except ImportError:
    raise Exception("aws_keys.py not found")

from pyspark.sql import SparkSession


def get_spark() -> SparkSession:
    warehouse_dir = "s3a://da-delta-lake-testing/test_warehouse_delta"
    builder = (
        pyspark.sql.SparkSession.builder.appName("TestApp")
        .config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension")
        .config(
            "spark.sql.catalog.spark_catalog",
            "org.apache.spark.sql.delta.catalog.DeltaCatalog",
        )
        .config(
            "spark.hadoop.fs.s3a.aws.credentials.provider",
            "org.apache.hadoop.fs.s3a.SimpleAWSCredentialsProvider",
        )
        .config("spark.hadoop.fs.s3a.access.key", aws_access_key_id)
        .config("spark.hadoop.fs.s3a.secret.key", aws_secret_access_key)
        .config("spark.sql.warehouse.dir", warehouse_dir)
        .config("spark.hadoop.fs.s3a.endpoint", "s3.amazonaws.com")
        .config("spark.hadoop.fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem")
    )
    # spark = builder.getOrCreate()
    spark = delta.configure_spark_with_delta_pip(builder).getOrCreate()
    spark.sparkContext.setLogLevel("ERROR")
    return spark


def create_dataset(i: int = 100) -> list[dict]:
    fake = mimesis.Generic()
    output = [
        {
            "name": fake.person.name(),
            "surname": fake.person.surname(),
            "birthday": fake.datetime.date(1960, 2010),
            "email": fake.person.email(),
            "country": fake.address.country(),
            "state": fake.address.state(),
            "city": fake.address.city(),
        }
        for _ in range(i)
    ]
    return output


def main():
    # dir = os.getcwd()
    spark = get_spark()

    print("Creating a dataset with 1000 rows")
    df = spark.createDataFrame(create_dataset(i=1_000))

    df = df.select(
        df.name, df.surname, df.birthday, df.email, df.country, df.state, df.city
    )

    spark.sql("CREATE DATABASE IF NOT EXISTS test_schema")
    df.write.mode("overwrite").format("delta").saveAsTable("test_schema.test_table")

    # // Read a Delta table on S3:
    spark.table("test_schema.test_table").show()


if __name__ == "__main__":
    main()
