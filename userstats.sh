#!/bin/bash

#output: nome_utilizador numero_sessões tempo_total duraçao_max duraçao_min
#tempo vem em minutos

# users-variavel para auxiliar a contruçao do output do programa
# vai servir para verificar quantos sessões cada utilizador tem
# para isso utilizar um array associativo em que a cada indice(nome do utlizador) esta associado o numero de sessões

# grep "\S"-remove todas as linhas em branco

users=$(last $USERS | column -t| awk '{print $1}' | grep "\S")
# numberUsers=$(last|awk "{print $1}| wc- w")
# grep -v "string" - procura pelas linhas que não contem a string

# declarar um array associativo
declare -A user

for i in $users; do
    if [ -z ${user[$i]} ]; then
        user[$i]=1
    else
        let "user[$i]++"
    fi
done

for x in "${!user[@]}"; do
    printf "%s  %s\n" $x ${user[$x]}
done

echo "-------------------------------------------------------------"

# Para obter os campos de tempo atraves do awk não se consegue para os casos do rebbot e wtmp pois os campos estão decalibrados
#relativamente ao aos utlizadores 

# miguel  :0      Wed   Nov  13   23:14     still  logged  in
# reboot  system  boot  Wed  Nov  13        23:14  still   running
# miguel  :0      Tue   Nov  12   09:20     -      14:45   (05:24)
# reboot  system  boot  Tue  Nov  12        09:20  -       14:45    (05:24)
# miguel  :0      Mon   Nov  11   12:25     -      21:23   (08:58)
# reboot  system  boot  Mon  Nov  11        12:24  -       21:23    (08:58)
# miguel  :0      Sun   Nov  10   10:55     -      down    (22:18)
# reboot  system  boot  Sun  Nov  10        10:55  -       09:14    (22:18)
# miguel  :0      Sun   Nov  10   10:51     -      10:55   (00:03)
# reboot  system  boot  Sun  Nov  10        10:51  -       10:55    (00:04)
# miguel  :0      Sun   Nov  10   10:44     -      crash   (00:06)
# reboot  system  boot  Sun  Nov  10        10:44  -       10:55    (00:10)
# miguel  tty1    Sun   Nov  10   10:18     -      10:44   (00:25)
# reboot  system  boot  Sun  Nov  10        10:18  -       10:44    (00:25)
# miguel  tty1    Sun   Nov  10   10:00     -      10:16   (00:16)
# reboot  system  boot  Sun  Nov  10        10:00  -       10:18    (00:18)
# wtmp    begins  Sun   Nov  10   09:59:52  2019


declare -A user_time

#users_times=$(last | awk '{print $9}' | grep "\S")

LAST=$(last)

# for x in "${!user[@]}"
# do
#     u=$(grep "$x")
#     if [ "$u" == "reboot "];then
#     users_time[$x]=$(last| grep "$u" | awk '{for(i=5;i<11;i++) print }' 


#     unset u

for i in "${!user_time[@]}"; do
    echo "${i}"
    echo "${user_time[$i]}"
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
