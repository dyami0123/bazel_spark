# Bazel Spark

## Problem Statement:

Pyspark and Delta-Lake are very powerful tools, but the requirement of workign with them via DataBricks can be restrictive for some projects. Although the two building blocks ([PySpark](https://www.databricks.com/glossary/pyspark) & [Delta-Lake](https://delta.io/) are open source) their setup & implementation can be tricky to get right. This project aims to fix that using [Bazel](https://bazel.build/) an automated application setup & testing framework. 

## Goals & Requirements
- Streamlined, One-Click Setup
- Environments setup using anaconda
    - Given that a large part of data science & analytics occurs using conda as an environment manager, this tool will be built on top of conda.
- Mutliple distinct environments can be supported on a single machine
    - modifications to a spark install for one environment should not interfere with other spark installs
- Support for S3 data storage
- Platform-Agnostic installation (Mac/Windows/Linux) *stretch goal*
- UI for better UX *stretch goal*

## Description

What it does:
- Creates a fresh conda environment based on the environment.yml file
- Installs Spark & Delta Lake into the conda environment, placing required files in the conda environment (e.g. env_name/lib/python3.11/site-packages/pyspark/...)
- configures the Spark environment to use Delta & S3


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
