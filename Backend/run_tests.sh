#!/bin/sh

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
export PYTHONPATH=${PYTHONPATH}:$SCRIPTPATH
python simplicityserver/test/server_routes_test_case.py
