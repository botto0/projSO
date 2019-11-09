#!/bin/bash
while getopts "ab" arg; do
    case $arg in
    "a") Name=$arg ;;
    "b") Name=$arg ;;

    esac
    echo "argumento : $Name!"
done
