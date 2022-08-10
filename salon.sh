#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~"

echo -e "\nWelcome to My Salon, how can I help you?"

if [[ ! -z $1 ]]
then
  echo -e $1
fi
SERVICE_LIST="$($PSQL "SELECT service_id, name FROM services")"


while [[ -z $SERVICE_SELECTION_RESULT ]]
do
  echo "$SERVICE_LIST" | while read SERVICE_ID BAR NAME
  do
    if [[ $SERVICE_ID =~ ^[0-9]+ ]]
    then
      echo "$SERVICE_ID) $NAME"
    fi
  done

  read SERVICE_ID_SELECTED
  SERVICE_SELECTION_RESULT="$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")"

  if [[ -z $SERVICE_SELECTION_RESULT ]]
  then
    echo -e "\nI could not find that service. What would you like today?"
  fi
done


echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

CUSTOMER_NAME="$($PSQL "SELECT  name FROM customers WHERE phone='$CUSTOMER_PHONE'")"

if [[ -z $CUSTOMER_NAME ]]
then
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME

  NEW_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
fi

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

SERVICE_NAME_TRIMMED=$(echo $SERVICE_SELECTION_RESULT | sed -r 's/^ *| *$//g')

echo -e "\nWhat time would you like your $SERVICE_NAME_TRIMMED, $CUSTOMER_NAME?"
read SERVICE_TIME

APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

echo -e "\nI have put you down for a $SERVICE_NAME_TRIMMED at $SERVICE_TIME, $CUSTOMER_NAME."




