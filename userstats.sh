#!/bin/bash

#output: nome_utilizador numero_sessões tempo_total duraçao_max duraçao_min
#tempo vem em minutos

# users-variavel para auxiliar a contruçao do output do programa
# vai servir para verificar quantos sessões cada utilizador tem
# para isso utilizar um array associativo em que a cada indice(nome do utlizador) esta associado o numero de sessões 


#col-numero de colunas da matrix -> cada utilizador
#line-linha da matriz que corresponde aos stats de cada utilizador que são 5


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


#--------------------------------------------Functions------------------------------------------------

 # a funçao que converte o tempo em minutos
function convertTime(){


    # processar a informação
     horas=$( echo "$1" | tr -d '()'| cut -d':' -f 1 |bc)
     minutos=$( echo "$1" | tr -d '()'| cut -d':' -f 2| bc)

    # bc faz os calculos e tambem converte para interio

    
    #conveter 
    let "t = $(( $horas*60 + $minutos ))" # converter o tempo todo em minutos
    
}

#----------------------------------Declaração de Variaveis------------------------------------------------------------------

declare -A user_time         #informação dos tempos               
declare -A user_time_min     #tempo minimo 
declare -A user_time_max     #tempo maximo
declare -A user_time_total   #tempo total
declare -A user              #utilizadores (todos diferentes)
declare -A options

R=0;
ORDEM=1;

unset Name EXP_REGULAR INICIO FIM CAMINHO USER_OP

#-----------------------------------Argumentos do Script---------------------------------------------
    options["last"]="-R"

while getopts ":g:u:s:e:f:rntai" arg; do                      
    case ${arg} in
                        
    "g") Name=$OPTARG ;;   

    "u") EXP_REGULAR=$OPTARG;;
                            
    "s") INICIO=$(date -d "$OPTARG" +"%Y-%m-%d %T")
        options["-s"]='"$INICIO"'
    ;;
    "e") FIM=$(date -d "$OPTARG" +"%Y-%m-%d %T") 
        options["-t"]='"$FIM"'  
        ;;   
                    
    "f") options["-f"]=$OPTARG ;;              
    "r") R=1;;                       
    "n") ORDEM=2 ;;                                 
    "t") ORDEM=3 ;;                                 
    "a") ORDEM=4 ;;                                 
    "i") ORDEM=5  ;;
    *) echo "Parametro Invalido"
    exit 0;;
    
    esac
done


    # grep "\S"-remove todas as linhas em branco
    
#---------------------------------Processamento de Dados----------------------------------------------
 
 stats=""
        for key in "${!options[@]}";do
           
            stats+="$key "${options[$key]}" "

        done
 
    if [ ! -z "$EXP_REGULAR" ];then

        stats+="| grep $EXP_REGULAR"
        

    fi

    users=$(eval "$stats" |grep -v reboot| grep -v wtmp  | cut -d " " -f 1 -s)

    if [ ! -z "$Name" ];then
        a=$(last -R| grep -v "reboot"| grep -v wtmp  | cut -d " " -f 1 -s| sort -u)
 
            for u in $a;do 
                grupo=$( id -nG $u | grep -w $Name) 

                if [ -z "$grupo" ];then
                    users=$(echo "$users"| grep -v $u)
                fi
        done
    fi


  
    # numberUsers=$(last|awk "{print $1}| wc- w")
    # grep -v "string" - procura pelas linhas que não contem a string

    # declarar um array associativo


    for i in $users; do
        if [ -z "${user[$i]}" ]; then
            user[$i]=$(echo "$users" | grep "$i"| wc -l)
        fi
    done
    

echo "-------------------------------------------------------------"

    for u in "${!user[@]}";do


        user_time[$u]=$(eval "$stats" | grep "$u"| awk '{print $4, $5 ,$9}')
    
    done

  

#u-utilizador
#x-tempos associados a cada utilizador

for u in "${!user_time[@]}";do

    # x=$( echo "${user_time[$u]}" | awk '{print $6}'| grep -v "in" | grep -v "no"| grep -v "(-177") 
    x=$(echo "${user_time[$u]}"| cut -d " " -f 3 | grep -v "[a-z.]")

     

    for i in ${x};do
        
        # echo "---"
        convertTime "$i"
        if [ -z "$max" ] && [ -z "$min" ];then
            max=$t
            min=$t
        fi

        if [ "$t" -gt "$max" ];then

            max=$t
        fi

        if [ "$t" -lt "$min" ];then
            min=$t
        fi

        let "user_time_total[$u]+= $t "
        

        unset x # libertar variavel

    done

    user_time_min[$u]=$min
    user_time_max[$u]=$max

    
 # faz com que para cada o utilizador o min e o max sejam redefinidos
    unset max
    unset min

done

#-----------------------------------Imprimir resultados-------------------------------------------------------------------


# ordenado pelo numero de utilizadores
if [ $R -eq 0 ];then
    for u in "${!user[@]}";do
        printf "%s   %s   %s  %s  %s \n" $u ${user[$u]} ${user_time_total[$u]} ${user_time_min[$u]} ${user_time_max[$u]}
    done |column -t | sort -n -k "$ORDEM"
    
else
    for u in "${!user[@]}";do
        printf "%s   %s   %s  %s  %s \n" $u ${user[$u]} ${user_time_total[$u]} ${user_time_min[$u]} ${user_time_max[$u]}
    done |column -t | sort -r -n -k "$ORDEM"
    
fi
