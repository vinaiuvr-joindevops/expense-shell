#!/bin/bash

#check user has root access or not
# store logs
# install mysql server
# enable it
# start it
# set the root password

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/expense-logs"
LOG_FILE=$(echo $0 | cut -d "." -f1 )
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE_NAME="$LOGS_FOLDER/$LOG_FILE-$TIMESTAMP.log"

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then
        echo "ERROR:: You must have sudo access to execute this script"
        exit 1 #other than 0
    fi
}

echo "Script started executing at: $TIMESTAMP" &>>$LOG_FILE_NAME

CHECK_ROOT

dnf install mysql-server -y &>>$LOG_FILE_NAME
VALIDATE $? "Installing MySQL Server"

systemctl enable mysqld &>>$LOG_FILE_NAME
VALIDATE $? "Enabling MySQL Server"

systemctl start mysqld &>>$LOG_FILE_NAME
VALIDATE $? "Starting MySQL Server"

mysql -h mysql.devopsaws-82.site -u root -pExpenseApp@1 -e 'show databases;' &>>$LOG_FILE_NAME