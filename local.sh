#?/bin/bash

if [ $1 == 'start' ]
then
  echo 'Docker compose'
  docker compose -f .localdevcontainer/local-docker-compose.yml up --build
fi

if [ $1 == 'copy' ]
then
  echo 'Docker copy'
  docker cp app:/code/node_modules ./
fi