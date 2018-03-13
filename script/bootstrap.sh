#!/bin/bash
# Usage: script/bootstrap
# Ensures all dependencies are installed locally.

set -e

cd "$(dirname $0)"/..
ROOT=$(pwd)

if [ -z "$VENV_NAME" ]; then
    VENV_NAME="env"
fi

if [ -z "$VENV_PYTHON" ]; then
    VENV_PYTHON=`which python`
fi
virtualenv --python=$VENV_PYTHON $VENV_NAME

source "$VENV_NAME/bin/activate"

pip install -U -r requirements.txt

echo ""
echo "Run source env/bin/activate to get your shell in to the virtualenv"
echo "See README.md for more information."
echo ""