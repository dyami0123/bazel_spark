# conda_spark_setup

This is a repository to help setup a conda environment for Spark and Delta Lake.

The thought is that these files can be copied into a repo of your own and then used to create a conda environment for Spark and Delta Lake. Default installs of spark & delta lake are simple, but I personally ran into issues with juggling multiple environments, and where to put the files. additionally, the follow on configuration of the spark install for Delta & S3 compatibility is a bit of a pain.

so, this aims to automate this process!

What it does:
- Creates a fresh conda environment based on the environment.yml file
- Installs Spark & Delta Lake into the conda environment, placing required files in the conda environment (e.g. env_name/lib/python3.11/site-packages/pyspark/...)
- configures the Spark environment to use Delta & S3

note: this is still a work in progress, and is not yet ready for use.

## Prerequisites

MacOS/Linux:
- [Homebrew](https://brew.sh/)

Windows:
- [Chocolatey](https://chocolatey.org/)? # TODO: test this

## Dependencies
- [Bazel](https://bazel.build/)
- [Conda](https://docs.conda.io/en/latest/)
- [PySpark](https://spark.apache.org/docs/latest/api/python/index.html)
- [Delta Lake](https://delta.io/)

## Setup

1. Copy the files in this repository into a new/existing repo.
2. update the environment.yml to match the requirements of your project.
3. run `./setup.sh` to install Spark and Delta Lake into the conda environment.

## Manual setup

1. run 

```bash
bazel build spark
bazel clean
```