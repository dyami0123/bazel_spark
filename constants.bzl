

def join_paths(*segments):
    return _get_file_separator().join(segments)
    
def _get_file_separator():
    return "/" #TODO: make this cross platform

def get_value(package_name, type):
    if type == "version":
        return _get_version(package_name)
    elif type == "filename":
        return _get_filename(package_name)
    elif type == "url":
        return _get_url(package_name)
    elif type == "hash":
        return _get_hash(package_name)
    elif type == "env_name":
        return _get_env_name()
    else:
        fail("Unknown type %s" % type)

def _get_env_name():
    return ENV_NAME

ENV_NAME = "delta_testing_bazel_other"

VERSIONS = {
    "PYTHON": "3.11",
    "SPARK": "3.5.1",
    "HADOOP": "3.3.6",
    "AWS_SDK": "1.12.376",
    "DELTA_SPARK": "3.2.0",
    "DELTA_SPARK_PARENT": "2.13",
}

FORMATTERS = {
    "SPARK" : {
        "filename" : "spark-{version}-bin-without-hadoop",
        "url" : "https://archive.apache.org/dist/spark/spark-{version}/{filename}.tgz",
        "hash" : "5548c02625676fa97cb6b8072f131ed0b860a09d1e86be4e025d0cbfa869bc4a",
    },
    "HADOOP" : {
        "filename" : "hadoop-{version}",
        "url" : "https://downloads.apache.org/hadoop/core/hadoop-{version}/{filename}.tar.gz",
        "hash" : "f5195059c0d4102adaa7fff17f7b2a85df906bcb6e19948716319f9978641a04",
    },
    "AWS_SDK" : {
        "filename" : "aws-java-sdk-s3-{version}.jar",
        "url" : "https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-s3/{version}/{filename}",
        "hash" : "6a363bc835a166153b71599b88a3a725f19ec6ab",
    },
    "DELTA_SPARK" : {
        "filename" : "delta-spark_{parent}-{version}.jar",
        "url" : "https://repo1.maven.org/maven2/io/delta/delta-spark_{parent}/{version}/{filename}",
        "hash" : "sha256:ee9ae1a4a5ef0e0a0d0f7a3a9b4c9e8ae4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4",
    },
}

def _get_version(package_name):
    return VERSIONS[package_name]

def _get_filename(package_name):
    if package_name == "DELTA_SPARK":
        return FORMATTERS[package_name]["filename"].format(parent=_get_version("DELTA_SPARK_PARENT"), version=_get_version("DELTA_SPARK"))
    else:
        return FORMATTERS[package_name]["filename"].format(version=_get_version(package_name))

def _get_url(package_name):
    if package_name == "DELTA_SPARK":
        return FORMATTERS[package_name]["url"].format(parent=_get_version("DELTA_SPARK_PARENT"), version=_get_version(package_name), filename=_get_filename(package_name))
    else:
        return FORMATTERS[package_name]["url"].format(version=_get_version(package_name), filename=_get_filename(package_name))

def _get_hash(package_name):
    # return HASHES[package_name]
    return FORMATTERS[package_name]["hash"]
