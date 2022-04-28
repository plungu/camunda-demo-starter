#!/bin/bash

## Install Heroku CLI
# https://devcenter.heroku.com/articles/heroku-cli

## Use the CLI to install the apps with the following commands

## Other config options
# Applied JAVA memory options for Heroku
# https://devcenter.heroku.com/articles/java-memory-issues#configuring-java-to-run-in-a-container
# https://devcenter.heroku.com/articles/getting-started-with-java

# Deploying Containers
# https://devcenter.heroku.com/articles/container-registry-and-runtime#getting-started

# Config environment variables
# https://devcenter.heroku.com/articles/config-vars
# https://devcenter.heroku.com/articles/config-vars#managing-config-vars

# C8 Clinet Configs
clusterId=1fe5aee7-1d1a-4164-ae0c-fa2636b53ce0
clientId=oHMuUuG3WTeSdzZS99t7iepG.GNIISgA
clientSecret=ZWowBVKp41Cq99kXmsa4WOa_isw2Luo8c_hXP.2SvdbNIuFPqXvGMTaomVi~Mtxm
herokuUser=""
herokuAuthTocken=heroku auth:token

commands="Commands: help, login, docker, list, install, delete, quit"

cmd=$1
if [ -z cmd ]
then
 echo $commands
 read cmd
fi

#loop=true
#while [ $loop ]
#do

echo "Executing $cmd"

if [ $cmd == "help" ];
then
echo $commands
fi

if [ $cmd == 'list' ];
then
echo "Listing Apps"
heroku apps
fi

if [ $cmd == 'login' ];
then
heroku login
fi

if [ $cmd == 'docker' ];
then
 docker login --username=${herokuUser} --password=${herokuAuthTocken} registry.heroku.com
fi


if [ $cmd == 'install' ];
then
echo "Installing Workflow Apps"

## BIZ DATA API
cd ./camunda-data-api-demo
heroku create --app wf-data-app-test
heroku addons:create heroku-postgresql:hobby-dev --app wf-data-app-test
dbcreds=$(heroku pg:credentials:url --app wf-data-app-test) ; echo $dbcreds
dbcreds=${dbcreds#*\"} ; dbcreds=${dbcreds%%\"*} ; echo $dbcreds
dbname=$(echo $dbcreds | sed -r 's/[[:alnum:]]+=/\n&/g' | awk -F= '$1=="dbname"{print $2}' | xargs) ; echo $dbname
dbuser=$(echo $dbcreds | sed -r 's/[[:alnum:]]+=/\n&/g' | awk -F= '$1=="user"{print $2}' | xargs) ; echo $dbuser
dbpassword=$(echo $dbcreds | sed -r 's/[[:alnum:]]+=/\n&/g' | awk -F= '$1=="password"{print $2}' | xargs) ; echo $dbpassword
dbhost=$(echo $dbcreds | sed -r 's/[[:alnum:]]+=/\n&/g' | awk -F= '$1=="host"{print $2}' | xargs) ; echo $dbhost
dbport=$(echo $dbcreds | sed -r 's/[[:alnum:]]+=/\n&/g' | awk -F= '$1=="port"{print $2}' | xargs) ; echo $dbport
dburl=jdbc:postgresql://${dbhost}:${dbport}/${dbname} ; echo $dburl
heroku config:set DB_URL=${dburl} --app wf-data-app-test
heroku config:set DB_USER=${dbuser} --app wf-data-app-test
heroku config:set DB_PASSWORD=${dbpassword} --app wf-data-app-test
heroku config:set MAX_POOL_SIZE=10 --app wf-data-app-test
heroku config:set DATABASE_DRIVER=org.postgresql.Driver --app wf-data-app-test
heroku config:set PROFILES=data,user,case,cors,prod --app wf-data-app-test
heroku config:set CAMUNDA_HOST=https://wf-c7-engine-app-test.herokuapp.com/ --app wf-data-app-test
heroku config:set CAMUNDA_PORT=80 --app wf-data-app-test
heroku container:push web --app wf-data-app-test
heroku container:release web --app wf-data-app-test
#heroku logs --tail --app wf-data-app-test
cd ..

## Reactjs Demo App
cd ./camunda-reactjs-demo
heroku create --app wf-react-app-test
heroku config:set PROFILES=cors,prod --app wf-react-app-test
heroku container:push web --app wf-react-app-test
heroku container:release web --app wf-react-app-test
#heroku logs --tail --app wf-react-app-test
cd ..

## C8 Client
cd ./camunda-8-spring-boot-client
heroku create --app wf-c8-client-app-test
heroku config:set PROFILES=cors,prod --app wf-c8-client-app-test
heroku config:set CLUSTER_ID=${clusterId} --app wf-c8-client-app-test
heroku config:set CLIENT_ID=${clientId} --app wf-c8-client-app-test
heroku config:set CLIENT_SECRET=${clientSecret} --app wf-c8-client-app-test
heroku container:push web --app wf-c8-client-app-test
heroku container:release web --app wf-c8-client-app-test
#heroku logs --tail --app wf-c8-client-app-test
cd ..

## C7 Client
cd ./camunda-7-spring-boot-client
heroku create --app wf-c7-client-app-test
heroku config:set PROFILES=cors,prod  --app wf-c7-client-app-test
heroku config:set CAMUNDA_API=https://wf-c7-engine-app-test.herokuapp.com/engine-rest/message --app wf-c7-client-app-test
heroku container:push web --app wf-c7-client-app-test
heroku container:release web --app wf-c7-client-app-test
#heroku logs --tail --app wf-c7-client-app-test
cd ..

## C7 Spring Boot Engine
cd ./camunda-platform-spring-boot
heroku create --app wf-c7-engine-app-test
heroku config:set PROFILES=cors,prod --app wf-c7-engine-app-test
heroku config:set DB_URL=${dburl} --app wf-c7-engine-app-test
heroku config:set DB_USER=${dbuser} --app wf-c7-engine-app-test
heroku config:set DB_PASSWORD=${dbpassword} --app wf-c7-engine-app-test
heroku config:set MAX_POOL_SIZE=10 --app wf-c7-engine-app-test
heroku config:set DATABASE_DRIVER=org.postgresql.Driver --app wf-c7-engine-app-test
heroku config:set DATA_API_URI=https://wf-data-app-test.herokuapp.com/api --app wf-c7-engine-app-test
heroku container:push web --app wf-c7-engine-app-test
heroku container:release web --app wf-c7-engine-app-test
#heroku logs --tail --app wf-c7-engine-app-test
cd ..
fi

if [ $cmd == 'delete' ];
then
echo "Deleting Apps"
heroku destroy --app wf-c7-engine-app-test --confirm wf-c7-engine-app-test
heroku destroy --app wf-react-app-test --confirm wf-react-app-test
heroku destroy --app wf-data-app-test --confirm wf-data-app-test
heroku destroy --app wf-c7-client-app-test --confirm wf-c7-client-app-test
heroku destroy --app wf-c8-client-app-test --confirm wf-c8-client-app-test
fi

if [ $cmd == 'quit' ];
then
  $loop = false;
  break
fi


echo $commands
echo "Finished Executing $cmd command"
#done
