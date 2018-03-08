#!/bin/bash

for var in "$@"
do
    echo "$(cat /proc/$var/stat)"
done