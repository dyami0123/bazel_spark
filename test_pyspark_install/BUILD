
load("//:constants.bzl", "join_paths", "get_value")

genrule(
    name = "test_pyspark_install",
    srcs = [":test.py"],
    outs = ["test_stdout.txt"],
    cmd = """
    source activate %s || conda activate %s
    python $(location test.py) > $@

    """ % (
        get_value("", "env_name"),
        get_value("", "env_name"),
        )
)