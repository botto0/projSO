#!/usr/local/bin/bash

#output: nome_utilizador numero_sessões tempo_total duraçao_max duraçao_min
#tempo vem em minutos

# users-variavel para auxiliar a contruçao do output do programa
# vai servir para verificar quantos sessões cada utilizador tem
# para isso utilizar um array associativo em que a cada indice(nome do utlizador) esta associado o numero de sessões

# grep "\S"-remove todas as linhas em branco
declare -A user

users=$(last | awk '{print $1}' | grep "\S")
# numberUsers=$(last|awk "{print $1}| wc- w")

# declarar um array associativo

for i in $users; do
    if [ -z ${user[$i]} ]; then
        user[$i]=1

    else
        let "user[$i]++"

    fi

done

for x in "${!user[@]}"; do
    echo "${x}"
    echo "${user[$x]}"
done

# opções:
# "-g"-filtrar por grupo
# "-u "-filtra por expressão regular que verificada pelo nome do utilizador
# "-s "-filtrar por periodo (inicio)
# "-e "-filtrar por periodo (fim)
# "-f"-usar um ficheiro distinto para a informação das sessões (por defeito:/var/log/wtmp)

# opções ordenação:
# "-r"-ordem decrescente de nome de utilizador
# "-n "-numero de sessões
# "-t "-tempo total
# "-a "-tempo maximo
# "-i "-tempo minimo

#$OPTARG-variavel passada como argumento da função
#Ex: -f nome -> $OPTARG=nome

unset Name EXP_REGULAR INICIO FIM CAMINHO

while getopts "gu:s:e:f:rntai" arg; do
    case $arg in
    "g") Name=$arg ;;
    "u") EXP_REGULAR=$OPTARG ;;
    "s") INICIO=$OPTARG ;;
    "e") FIM=$OPTARG ;;
    "f") CAMINHO=$OPTARG ;;
    "r") ;;
    "n") ;;
    "t") ;;
    "a") ;;
    "i") ;;
    esac
    echo "argumento : $INICIO!"
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
