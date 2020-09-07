#!/bin/bash

set -e

BASE="$(readlink -f $(dirname "${BASH_SOURCE[0]}"))"
echo $BASE

export CIQ_WORKSPACE="$BASE"
#export COMMAND="ls /home/developer/eclipse-workspace"
export COMMAND="/bin/bash /home/developer/eclipse-workspace/monkey.sh"

cd ~/docker-connectiq
./run.sh
