#!/bin/bash

echo
echo "Create a new DB (Name: tpch), and import the data.";
echo
echo "This will take a few minutes, please wait";
echo "You can also check the prograss, using below command with root privileges. (mysql -uroot -p)";
echo "     show processlist;"
echo
echo "To insert the data to DB, Enter the database user password."
echo

sudo mysql -u ${1?The script should be executed as follows: ./import_TPC_H_to_MySQL.sh <DB Username>} -p  < TPC_H_to_MySQL.sql

echo
echo "Complete. Please check if there was SQL Syntax Error."
echo "If the error has occured, Please check the log, and correct it and try again."
echo