#/home/script
apps="docker docker-compose"
apt-get -y --ignore-missing install $apps
docker -v
docker-compose -v
