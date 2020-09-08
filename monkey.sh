#!/bin/bash

set -e

BASE=/home/developer/eclipse-workspace
DEVICE=fr230

if [ ! -d /home/developer/eclipse-workspace ]
then
    echo
    echo 'Exiting: only run this script inside Docker; outside, try ./run.sh'
    echo
    exit 1
fi

cd $BASE
#cd LatLonField; NAME=latlonfield
cd UTMField; NAME=utmfield
monkeyc -d $DEVICE \
        -f ./monkey.jungle \
        --output $NAME.prg \
        --warn \
        -y ~/eclipse-workspace/developer_key.der
connectiq &
monkeydo $NAME.prg $DEVICE
