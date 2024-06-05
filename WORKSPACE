load("//:constants.bzl", "get_value")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")

http_file(
    name =  "aws_sdk_archive",
    url = get_value("AWS_SDK", "url"),
    downloaded_file_path = get_value("AWS_SDK", "filename"),
)

http_archive(
    name = "hadoop_archive",
    url = get_value("HADOOP", "url"),
    # sha256 = get_hash("HADOOP"),
    strip_prefix = get_value("HADOOP", "filename"),
    add_prefix = "hadoop_files_dir",
    build_file_content = """
filegroup(
    name = "hadoop_files",
    srcs = ["hadoop_files_dir"],
    visibility = ["//visibility:public"],
)
    """
)

http_archive(
    name = "spark_archive",
    url = get_value("SPARK", "url"),
    # sha256 = get_hash("SPARK"),
    strip_prefix = get_value("SPARK", "filename"),
    add_prefix = "spark_files_dir",
    build_file_content = """

filegroup(
    name = "spark_files",
    srcs = ["spark_files_dir"],
    visibility = ["//visibility:public"],
)
    """
)