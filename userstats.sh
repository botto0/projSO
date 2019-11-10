#!/bin/bash


#output: nome_utilizador numero_sessões tempo_total duraçao_max duraçao_min
#tempo vem em minutos

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

while getopts "gu:s:e:f:rntai" arg; do
    case $arg in
    "g") Name=$arg ;;
    "u") EXP_REGULAR=$OPTARG ;;
    "s") INICIO=$OPTARG ;;
    "e") FIM=$OPTARG ;;
    "f") CAMINHO=$OPTARG ;;
    "r");;    
    "n");;
    "t");;
    "a");;
    "i")  ;;  
    esac
    echo "argumento : $INICIO!"
done
