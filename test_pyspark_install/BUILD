load("//:constants.bzl", "join_paths", "get_value")

genrule(
    name="test_pyspark_install",
    srcs=[":test.py"],
    outs=["test_stdout.txt"],
    cmd="""
    eval "$$(conda shell.bash hook)" && conda activate %s
    pip install delta-spark==%s mimesis
    python $(location test.py) > $@

    """
    % (get_value("", "env_name"), get_value("DELTA_SPARK", "version")),
)
