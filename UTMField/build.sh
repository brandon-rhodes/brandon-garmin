#!/bin/bash

monkeyc --warn \
        --output latlon.prg \
        -y developer_key.der \
        -f UTMField/monkey.jungle &&
    monkeydo ./app.prg fr230
