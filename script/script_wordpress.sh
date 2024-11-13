docker network create --subnet 172.20.0.0/16 --ip-range 172.20.240.0/20 wordpress-net

docker run --name mysql-server-wordpress -t \
             -e MYSQL_DATABASE="wordpress" \
             -e MYSQL_USER="wordpress" \
             -e MYSQL_PASSWORD="wordpress_pwd" \
             -e MYSQL_ROOT_PASSWORD="root_pwd" \
             --network=wordpresse-net \
             --restart unless-stopped \
             -d mysql:8.0-oracle \
             --character-set-server=utf8 --collation-server=utf8_bin \
             --default-authentication-plugin=mysql_native_password 
             
docker run --name wordpress --network wordpress-net -p 8090:80 -d wordpress
