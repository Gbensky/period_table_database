#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
else
  if [[ ! $1  =~ ^[0-9]+$ ]]
    then
     GET_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1' OR symbol='$1'")
  else
     GET_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
  fi
  if [[ -z $GET_ATOMIC_NUMBER ]]
  then
    echo -e "I could not find that element in the database."
  else
    GET_PROPERTIES=$($PSQL "SELECT elements.atomic_number as atomic_number, name, symbol, types.type as type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE elements.atomic_number=$GET_ATOMIC_NUMBER ORDER BY elements.atomic_number")
    echo "$GET_PROPERTIES" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done
  fi
fi