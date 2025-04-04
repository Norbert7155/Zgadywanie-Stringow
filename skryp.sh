#!/usr/bin/env bash
# POMOC

Help() {
cat <<EOF
  Użycie: $0 -p <ciąg> -s <strategia> -t <typ> [opcje]

  Opcje:
    -h               Pomoc
    -p ciąg          Ciag do zgadnięcia
    -s strategia     Strategia zgadywania: random lub incremental
    -t typ           Male lub Duze/male litery do losowania: lower lub mixed 

EOF
}

#Funkcja z zestawem znakow
Initialization() {
  local type="$1"
  local model="$2"
  
  case "$type" in
    lower)
      CHARSET="abcdefghijklmnopqrstuvwxyz"
      Smallmodel="^[a-z]+$"
      ;;
    mixed)
      CHARSET="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
      Smallmodel="^[A-Za-z]+$"
      ;;
    *)
      echo "Niepoprawny typ znakow: lower lub mixed" >&2
      exit 1
        ;
      ;
  esac


  if ! [[ "$model" =~ $Smallmodel ]]; then
    echo "Wzorzec \"$model\" zawiera niepoprawne znaki dla typu \"$type\"." >&2
    exit 1
  fi
}


# funkcja losujaca znak

RandomChar() {
  
    head /dev/urandom | tr -dc "$CHARSET" | head -c 1
}


#  funkcja losujaca ciag o $1 dlugosci

RandomString() {
  local length="$1"
  local output=""

  for ((i=0; i<length; i++)); do
  #losujemy znaki z zestawu
    output+=$(RandomChar)
  done

  echo "$output"
}


# Funkcja do zastępowania znaku w ciągu
# Funkcja przyjmuje 3 argumenty oryginalny ciag indeks znaku do zastąpienia i nowy znak

ReplaceChar() {
  local original="$1"
  local index="$2"
  local new_char="$3"
  echo "${original:0:index}${new_char}${original:index+1}"
}


# strategia random w każdej iteracji generujemy calosc od nowa  :)

RandomMethod() {
  local target="$1"
  local length="${#target}"

  local iteration=0
  local guess=""

  echo "Strategia-RANDOM"

  while true; do
    ((iteration++))
    guess=$(RandomString "$length")

    if [[ "$guess" == "$target" ]]; then
      echo "Zgadnięto wzorzec \"$target\" w $iteration iteracjach"
      break
    fi
  done
}


# strategia incremental losujemy tylko zle znaki.
IncrementallyMethod() {
  local target="$1"
  local length="${#target}"
  local iteration=0
  local guess

  echo "Strategia-INCREMENTAL"

  
  guess=$(RandomString "$length")

  while true;
    do
      ((iteration++))
      for (( i=0; i<length; i++ ));   do
        if  [[ "${guess:i:1}" != "${target:i:1}" ]];   then
          guess=$(ReplaceChar "$guess" "$i" "$(RandomChar)")
        fi
      done

      if [[ "$guess" == "$target"]];   then
        echo "Zgadnięto wzorzec \"$target\"  w $iteration iteracjach"
        break
    fi
  done
}



  #Zmienne
  MODEL=""
  STRATEGY=""
  TYPE=""
  CHARSET=""         
  Smallmodel=""   


# getopts

while getopts ":hp:s:t:" opt;  do
  case "$opt" in
    h)
      Help
      exit 0
        ;
      ;
    p)
      MODEL="$OPTARG"
        ;
      ;
    s)
      STRATEGY="$OPTARG"
        ;
      ;
    t)
      TYPE="$OPTARG"
        ;
      ;
    \?)
      echo "nieznany parametr: -$OPTARG" >&2
      Help
      exit 1
        ;
      ;
    :)
      echo "Brak wartości dla opcji -$OPTARG" >&2
      exit 1
        ;
      ; esac
  
done



# walidacja parametrow
if [[ -z "$MODEL" || -z "$STRATEGY" || -z "$TYPE" ]]; then
  echo "Błąd: nie podano wszystkich wymaganych parametrów (-p, -s, -t)." >&2
  Help

  exit 1
fi


# Inicjalizacja dozwolonego zbioru znakow 

Initialization "$TYPE" "$MODEL"

# Sprawdzenie strategi i wywolanie wlasciwej funkcji
case "$STRATEGY" in
  random)
     RandomMethod "$MODEL"
        ;
    ;
  incremental)
    IncrementallyMethod "$MODEL"
      ;
    ;
  *)
    echo "Niepoprawna strategia - wyswietli help -h" >&2
    exit 1
      ;
    ; esac

exit 0