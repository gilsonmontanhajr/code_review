#!/bin/bash
DC=$(which docker)

$DC rm airport-service-v110 airport-service country-service -f
$DC rmi lunatechbase
ssh-keygen -f $HOME/.ssh/known_hosts -R 172.18.0.10
ssh-keygen -f $HOME/.ssh/known_hosts -R 172.18.0.20
ssh-keygen -f $HOME/.ssh/known_hosts -R 172.18.0.30
