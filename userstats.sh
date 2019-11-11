#!/bin/bash
declare -a info_total
declare -a info_filtrada

info_filtrada[0] =lucas

for i in "${info_filtrada[@]}"
do
echo $i
done
# if [ "$#" -eq 0 ]; then
#     echo "teste"
# fi
# if (("$#" > 0)); then
#     while getopts "gusefrntai" arg; do
#         case $arg in
#         "g")
#             last | awk '{print $1, user++ }' | sort -
#             Name=$arg
#             ;;
#         "u") Name=$arg ;;
#         "s") Name=$arg ;;
#         "e") Name=$arg ;;
#         "f") Name=$arg ;;
#         "r") Name=$arg ;;
#         "n") Name=$arg ;;
#         "t") Name=$arg ;;
#         "a") Name=$arg ;;
#         "i") Name=$arg ;;
#         esac
#         echo "argumento : $Name"
#     done
# fi
