#!/bin/bash

monkeyc --warn \
        --output latlon.prg \
        -y developer_key.der \
        -f LatLonField/monkey.jungle &&
    monkeydo ./latlon.prg fr230
