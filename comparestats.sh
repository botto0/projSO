#!/usr/local/bin/bash
#sop0200 6 255 100 1 | nsessoes max_duration min_duration

# -------Usefull Tips------------------
# i=$(($i + 1)) ---- incrementar i
# echo ${#usersf2[@]} ---- ver tamanho do array

declare -A users # Armazena todos os users (ficheiro)
declare -a infoa # Guarda informações sobre cada user do ficheiro 1
declare -a infob # Guarda informações sobre cada user do ficheiro 2
declare -a tmp   # Guarda a diferença dos parâmetros do user com as novas stats encontradas

######### Verificar número de argumentos #########
echo "$#"
if [ $# -ne "2" ] && [ $# -ne "3" ] && [ $# -ne "4" ]; then
    echo "Illegal number of parameters"
    echo "This script only supports 2 or 3 parameters"
    exit 2
fi

######### Ler ficheiros e armazenar #########
# FICHEIRO 1
if [ -f "${@: -2:1}" ]; then
    while IFS=" " read -r a1 a2 a3 a4 a5; do
        infoa=("$a2" "$a3" "$a4" "$a5")
        users[$a1]=${infoa[@]}
    done <${@: -2:1}
else
    echo "${@: -2:1} does not exist"
    exit 2
fi
# FICHEIRO 2
if [ -f "${@: -1}" ]; then
    while IFS=" " read -r b1 b2 b3 b4 b5; do
        infob=("$b2" "$b3" "$b4" "$b5")

        if [[ -z ${users[$b1]} ]]; then
            users[$b1]=${infob[@]}
        else
            for ((i = 0; i < 4; i++)); do
                let "k=(("$i"+1))"
                a=$(($(echo "${users[$b1]}" | awk -v i="$k" '{print $i}')))
                let "tmp[$i] = $((infob[$i] - $a))"
            done
            users[$b1]=${tmp[@]}

        fi
    done <${@: -1}
else
    echo "${@: -1} does not exist"
    exit 2
fi

##############################################
R=0
ORDEM=1
while getopts "rntai" arg; do
    case ${arg} in

    "r") R=1 ;;
    "n") ORDEM=2 ;;
    "t") ORDEM=3 ;;
    "a") ORDEM=4 ;;
    "i") ORDEM=5 ;;

    *) echo "Parametro Invalido" ;;
    esac
done

if [ $R -eq 0 ]; then
    printf "\nConteúdo Dos Ficheiros Após a Diferença\n"
    printf "\n%s %s %s %s %s\n" "User" "Número de sessões" "Tempo Total" "Duração Máxima" "Duração Mínima"
    for k in "${!users[@]}"; do
        printf "%s " "$k"
        for i in ${users[$k]}; do
            printf "%s " "$i"
        done
        printf "\n"
    done | sort -n -k "$ORDEM"

else
    printf "\nConteúdo Dos Ficheiros Após a Diferença\n"
    printf "%s %s %s %s %s\n" "User" "Número de sessões" "Tempo Total" "Duração Máxima" "Duração Mínima"
    for k in "${!users[@]}"; do
        printf "%s " "$k"
        for i in ${users[$k]}; do
            printf "%s " "$i"
        done
        printf "\n"
    done | sort -r -n -k "$ORDEM"   
fi

printf "\n##############################################\n"
