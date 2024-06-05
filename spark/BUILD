# Create a new Conda environment
# BUILD
load("//:constants.bzl", "join_paths", "get_value")


genrule(
    name = "dump_urls_used",
    cmd = "echo 'URLS: \n%s\n%s\n%s\n%s\n' > $@" % (
        get_value("SPARK", "url"),
        get_value("HADOOP", "url"),
        get_value("AWS_SDK", "url"),
        get_value("DELTA_SPARK", "url"),
    ),
    outs = ["dump_urls_used.txt"],
)

genrule(
    name="create_conda_env",
    cmd = """
    conda create -n %s python=%s -y
    echo 'Conda environment created successfully: %s' > $@
""" % (get_value("", "env_name"), get_value("PYTHON", "version"), get_value("", "env_name")),
    outs=["conda_env_created.txt"],
    srcs=["dump_urls_used"],  
)


genrule(
    name="extract_pyspark_path",
    cmd = """
    source activate %s || conda activate %s
    echo $$(python -c 'import site; import os; print(os.path.join(site.getsitepackages()[0], "pyspark"))') > $@
""" % (get_value("", "env_name"), get_value("", "env_name")),
    srcs=[":create_conda_env"],
    outs=["pyspark_path.txt"],
)

genrule(
    name="extract_hadoop_path",
    cmd = """
    source activate %s || conda activate %s
    echo $$(python -c 'import site; import os; print(os.path.join(site.getsitepackages()[0], "pyspark", "hadoop"))') > $@
""" % (get_value("", "env_name"), get_value("", "env_name")),
    srcs=[":extract_pyspark_path"],
    outs=["hadoop_path.txt"],
)


genrule(
    name = "move_spark",
    srcs = ["@spark_archive//:spark_files", ":extract_pyspark_path"],
    outs = ["spark_moved.txt"],
    cmd = """
    PYSPARK_DIR=$$(cat $(location extract_pyspark_path))

    echo 'Moved files from $(location @spark_archive//:spark_files) to '$$PYSPARK_DIR > $@
    cp -r $(location @spark_archive//:spark_files) $$PYSPARK_DIR
    """,
)

genrule(
    name = "build_install_pyspark",
    srcs = [":move_spark", ":extract_pyspark_path"],
    outs = ["pyspark_installed.txt"],
    cmd = """
    PYSPARK_DIR=$$(cat $(location extract_pyspark_path))
    echo 'PySpark installed to '$$PYSPARK_DIR > $@
    cd %s
    python setup.py sdist
    pip install %s
    """ % (
        join_paths("$$PYSPARK_DIR", "python"),
        join_paths("dist", "pyspark-%s.tar.gz" % get_value("SPARK", "version"))
        )
)

genrule(
    name = "move_hadoop",
    srcs = ["@hadoop_archive//:hadoop_files", ":extract_hadoop_path", ":build_install_pyspark"],
    outs = ["hadoop_moved.txt"],
    cmd = """
    HADOOP_DIR=$$(cat $(location extract_hadoop_path))

    echo 'Moved files from $(location @hadoop_archive//:hadoop_files) to '$$HADOOP_DIR > $@
    cp -r $(location @hadoop_archive//:hadoop_files) $$HADOOP_DIR
    """,
)

genrule(
    name = "move_aws_sdk",
    srcs = ["@aws_sdk_archive//file", ":extract_hadoop_path", ":move_hadoop"],
    outs = ["aws_sdk_moved.txt"],
    cmd = """
    HADOOP_DIR=$$(cat $(location extract_hadoop_path))
    echo 'Moved files from $(location @aws_sdk_archive//file) to %s' > $@
    cp -r $(location @aws_sdk_archive//file) %s
    """ % (
        join_paths("'$$HADOOP_DIR'", "share", "hadoop", "tools", "lib"), 
        join_paths("$$HADOOP_DIR", "share", "hadoop", "tools", "lib")
        )
)

genrule(
    name = "spark",
    srcs = [":move_aws_sdk", ":extract_hadoop_path", ":extract_pyspark_path", ":build_install_pyspark"],
    outs = ["spark_hadoop_configured.txt"],
    cmd = """
    HADOOP_DIR=$$(cat $(location extract_hadoop_path))
    PYSPARK_DIR=$$(cat $(location extract_pyspark_path))
    echo 'export SPARK_DIST_CLASSPATH="%s:%s:%s:%s:%s:%s:%s:%s:%s:%s:%s:%s"' | tee -a %s
    echo 'Spark environment configured for Hadoop' > $@
    """ % (
        join_paths("'$$HADOOP_DIR'", "etc", "hadoop"),
        join_paths("'$$HADOOP_DIR'", "share", "hadoop", "common", "lib", "*"),
        join_paths("'$$HADOOP_DIR'", "share", "hadoop", "common", "*"),
        join_paths("'$$HADOOP_DIR'", "share", "hadoop", "hdfs"),
        join_paths("'$$HADOOP_DIR'", "share", "hadoop", "hdfs", "lib", "*"),
        join_paths("'$$HADOOP_DIR'", "share", "hadoop", "hdfs", "*"),
        join_paths("'$$HADOOP_DIR'", "share", "hadoop", "yarn", "lib", "*"),
        join_paths("'$$HADOOP_DIR'", "share", "hadoop", "yarn", "*"),
        join_paths("'$$HADOOP_DIR'", "share", "hadoop", "mapreduce", "lib", "*"),
        join_paths("'$$HADOOP_DIR'", "share", "hadoop", "mapreduce", "*"),
        join_paths(" ", "contrib", "capacity-scheduler", "*.jar"),
        join_paths("'$$HADOOP_DIR'", "share", "hadoop", "tools", "lib", "*"),
        join_paths("$$PYSPARK_DIR", "conf", "spark-env.sh")
    )
)