#!/bin/bash

set -e

if ! [ -d ~/docker-connectiq ]
then
    echo 'In your home directory, run:'
    echo 'git clone https://github.com/brandon-rhodes/docker-connectiq.git'
    exit 1
fi

BASE="$(readlink -f $(dirname "${BASH_SOURCE[0]}"))"
echo $BASE

export CIQ_WORKSPACE="$BASE"
export COMMAND="/bin/bash /home/developer/eclipse-workspace/monkey.sh"

cd ~/docker-connectiq
./run.sh
