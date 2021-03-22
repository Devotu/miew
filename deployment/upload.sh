#! /bin/bash

echo -e "version"
read version

echo ">>>> application"
echo "- fetching dependancies"
mix deps.get --only prod
echo "- dependancies done"

echo "-- compiling application"
MIX_ENV=prod mix compile
echo "-- application compiled"
echo "<<<< application done"

echo ">>>> assets"
echo "- updating js depencancies"
npm install --prefix ./assets
echo "- update done"

echo "-- compiling assets"
npm run deploy --prefix ./assets
echo "-- assets compiled"
mix phx.digest
echo "<<<< assets done"

echo ">>>> release"
echo "- building release"
MIX_ENV=prod mix release
echo "- release built"
echo "<<<< release done"

echo ">>>> package"
tar -zcf miew_$version.tar.gz _build/prod/rel/miew/
echo "<<<< package done"


#File containing actual address and credentials
#in format USER="xxx"
#must always be in .gitignore
echo ">>>> secrets"
source deployment/server.info
echo "<<<< secrets done"

echo ">>>> upload"
sshpass -p "$PASSWORD" scp miew_*.tar.gz $USER@$IP:.
echo "<<<< upload done"

echo "release $version built, packaged and uploaded"