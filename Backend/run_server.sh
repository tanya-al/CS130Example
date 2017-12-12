#!/bin/sh

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
export PYTHONPATH=${PYTHONPATH}:$SCRIPTPATH
python simplicityserver/app/server/server_routes.py
