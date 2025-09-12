#!/bin/bash
DIR=.

echo
echo "Create a new DB (Name: tpcds), and import the data.";
echo
echo "This will take a few minutes, please wait";
echo "You can also check the prograss, using below command with root privileges. (mysql -uroot -p)";
echo
echo "  show processlist;"
echo
echo "To insert the data to DB, Enter the database root user password."
echo
echo -n "  Enter Password: "
stty -echo
read password
export MYSQL_PWD=$password
stty echo
echo
echo
echo "Create database structure..."
echo
sudo MYSQL_PWD=$MYSQL_PWD mysql -uroot < TPC_DS_MySQL_Initialize.sql
echo

ls "$DIR"/*.dat | while read -r file; do
    table=$(basename "$file" .dat | sed -e 's/_[0-9]_[0-9]//')
    
    # Process the data and redirect it to MySQL
    echo "Import the data... {$file}"
    sudo MYSQL_PWD=$MYSQL_PWD mysql -uroot --local-infile=1 -Dtpcds -e \
          "load data local infile '$file' replace into table $table character set latin1 fields terminated by '|'"
done


echo
echo "Complete. Please check if there was SQL Syntax Error."
echo "If the error has occured, Please check the log, and correct it and try again."
echo
