#!/bin/bash
set -e
if [ ! -d "/projects/donkeycar" ] 
then
    echo "Cloning donkeycar repository."
    cd /projects
    python3 -m virtualenv -p python3 env --system-site-packages
    git clone https://github.com/autorope/donkeycar
    cd /projects/donkeycar
    git checkout master
    pip install -e .[nano]
    donkey createcar --path /projects/mycar --overwrite
fi
source /projects/env/bin/activate

exec "$@"