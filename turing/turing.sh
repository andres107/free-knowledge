#!/bin/bash
source './turing/lib/icons.bash'

env='default.env'
logo='./turing/logo.txt'

print_logo()
{
  eval "cat $logo"
}


up()
{
  eval "docker-compose up -d"
}

logs()
{
  eval "docker-compose logs -f -t"
}

down()
{
  eval "docker-compose stop"
}

build()
{
  if [ $IMAGE == 'django' ]
  then
    echo -e -n "${empty_start} Creating project in django..."
    eval "(docker-compose run $IMAGE django-admin startproject $PROJECT_NAME .) &>> error.log"
    echo -e "...done $five_start"
    echo  -e -n "${empty_start} Creating APP..."
    eval "(docker-compose run $IMAGE python manage.py startapp $APP_NAME) &>> error.log"
    echo -e "...done $five_start"
  else
    echo -e "\n\tThe file default.env no exist."
    exit
  fi
}

export_env()
{
  if [ -e $env ]
  then
    while read line
    do
      eval "export $line"
    done < $env
  fi
}

do_action()
{
  if [ $1 == 'build' ]
  then
    echo -e "\n${empty_start} Building the project.."
    build
    echo -e "...done $five_start"
  elif [ $1 == 'up' ]
  then
    up
  elif [ $1 == 'down' ]
  then
    down
  elif [ $1 == 'logs' ]
  then
    logs
  fi
}

parameters()
{
  if [ $1 != 1 ]
  then
    echo -e "\n Use"
    echo -e "\t$0 [OPTION]"
    echo -e " Options"
    echo -e "\tbuild     Build the project."
    exit
  fi
}

print_logo
parameters $#
export_env
do_action $1
