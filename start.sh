#!/bin/bash
DR=$(which docker)
BASE='lunatechbase'
SNET='ltech-subnet'
ASB=$(which ansible)

function dockering(){
    $DR build -t $BASE .
    $DR network create --driver=bridge --subnet=172.18.0.0/24 --gateway=172.18.0.1 $SNET

    echo "Creating the country-service"
    $DR run -v app:/app --name=country-service --net $SNET --ip 172.18.0.10 -ti -d $BASE /bin/bash
    $DR exec -it country-service service ssh start

    echo "Creating the airport-service"
    $DR run -v app:/app --name=airport-service --net $SNET --ip 172.18.0.20 -ti -d $BASE /bin/bash
    $DR exec -it airport-service service ssh start

    echo "Creating the airport-service-v110"
    $DR run -v app:/app --name=airport-service-v110 --net $SNET --ip 172.18.0.30 -ti -d $BASE /bin/bash
    $DR exec -it airport-service-v110 service ssh start
}

function deployments(){
    if [ ! -d app ]; then
        mkdir app/
    fi
    # most dificult part
#    if [ ! -f app/countries-assembly-1.0.1.jar ]; then
#        wget https://s3-eu-west-1.amazonaws.com/devops-assesment/countries-assembly-1.0.1.jar -O app/countries-assembly-1.0.1.jar
#    fi
#    if [ ! -f app/airports-assembly-1.0.1.jar ]; then
#        wget https://s3-eu-west-1.amazonaws.com/devops-assesment/airports-assembly-1.0.1.jar -O app/airports-assembly-1.0.1.jar
#    fi
#    if [ ! -f app/airports-assembly-1.1.0.jar ]; then
#        wget https://s3-eu-west-1.amazonaws.com/devops-assesment/airports-assembly-1.1.0.jar app/airports-assembly-1.1.0.jar
#    fi

    rsync -av keys /tmp
    $ASB-playbook code/main.yml -i code/hosts
}

if [ -f $DR ]; then
    echo "Creating infrastructure"
    dockering
else
    echo "Docker binary not found"
    exit 1
fi

if [ -f $ASB ]; then
    echo "Running the deployments"
    deployments
else
    echo "Docker binary not found"
    exit 1
fi
