

# check if brew is installed
if ! command -v brew &> /dev/null
then
  echo "Homebrew is not installed. the auto-setup script requires Homebrew to be installed."
  exit 1
fi

if ! command -v conda &> /dev/null
then
  echo "Conda is not installed. installing Conda with Homebrew."
  brew install conda
fi

if ! command -v bazel &> /dev/null
then
  echo "Bazel is not installed. installing Bazel with Homebrew."
  brew install bazel
fi

echo "Installing Spark & Delta into the configured conda environment using Bazel"
bazel build spark

echo "Cleaning up Bazel build files"
bazel clean

echo "Testing the Spark installation"
bazel test test_pyspark_install