# Script adapted from https://github.com/rasbt/mlxtend/blob/master/ci/.travis_install.sh
#!/usr/bin/env bash

set -e

wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh;

bash miniconda.sh -b -p $HOME/miniconda
export PATH="$HOME/miniconda/bin:$PATH"
hash -r
conda config --set always_yes yes --set changeps1 no
conda update -q conda
conda info -a

if [ "${LATEST}" = "true" ]; then
    conda create -q -n test-environment python=$TRAVIS_PYTHON_VERSION numpy scipy pandas scikit-learn;
else
    conda create -q -n test-environment python=$TRAVIS_PYTHON_VERSION numpy=$NUMPY_VERSION scipy=$SCIPY_VERSION pandas=$PANDAS_VERSION scikit-learn=$SKLEARN_VERSION;
fi

source activate test-environment

pip install nose nose-exclude;

if [ "${COVERAGE}" = "true" ]; then
    pip install coverage coveralls codecov;
fi

python --version
python -c "import pandas; print('pandas %s' % pandas.__version__)";
python -c "import numpy; print('numpy %s' % numpy.__version__)"
python -c "import scipy; print('scipy %s' % scipy.__version__)"

if [ "${TENSORFLOW}" = "true" ]; then
    conda install tensorflow=0.10
    python -c "import tensorflow; print('tensorflow %s' % tensorflow.__version__)";
else
    python -c "import sklearn; print('sklearn %s' % sklearn.__version__)";
fi

if [ "${NOTEBOOKS}" = "true" ]; then
    conda install jupyter matplotlib
  fi

python setup.py install;