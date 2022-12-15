#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~ Welcome to the salon ~~~~\n"

SERVICE_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n--------------------\n\n$1\n"
  fi

  echo -e "Please select the service you wish to book:"
  # get services and display them formatted correctly
  SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
  echo -e "\n0) Exit\n"
  # get service selection
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) SET_APPOINTMENT ;;
    2) SET_APPOINTMENT ;;
    3) SET_APPOINTMENT ;;
    4) SET_APPOINTMENT ;;
    0) EXIT ;;
    *) SERVICE_MENU "That is not a valid service to book." ;;
  esac
}

SET_APPOINTMENT() {
  #get phone number
  echo -e "\nPlease enter your phone number:"
  read CUSTOMER_PHONE

  # get customer name
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  CUSTOMER_NAME=$(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')

  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nPlease enter your name:"
    read CUSTOMER_NAME
    # insert new customer details
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi

  # get customer id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  CUSTOMER_ID=$(echo $CUSTOMER_ID | sed -r 's/^ *//g')

  # get appointment time
  echo -e "\nWhat time would you like to book your appointment for?"
  read SERVICE_TIME

  # get service name
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

  # insert into appointments table
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  echo -e "\nI have put you down for a $(echo $SERVICE_NAME | sed 's/ |/"/') at $SERVICE_TIME, $CUSTOMER_NAME.\n"
}

SERVICE_MENU
