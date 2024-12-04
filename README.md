# Comment utiliser Docker ?

## Machine d'exemple :
- WordPress : IP:8090
- Zabbix : IP
---

## Installer Docker et Docker-compose

- Pour ce faire, rien de plus simple ! Une fois sur votre machine en SSH (ou non, mais vous pouvez Copier coller avec ce dernier), exécutez : 
  ```bash
  cd /home
  ```

- Ensuite, installez GIT : 
  ```bash
  apt install git
  ```

- Et clonez notre dépôt distant : 
  ```bash
  git clone https://github.com/spqraxel/TP-Bilan
  ```

- Maintenant, allez dans le dossier `script` : 
  ```bash
  cd /TP-Bilan/script
  ```

  Puis lancez le script d'installation de Docker : 
  ```bash
  sh install_docker.sh

  Il est possible que pendant l'importation install_docker na aucun droit, de fait : chmod 777 install_docker.sh
  ```

---

## Une fois les étapes terminées, vous avez Docker et GIT installés. Nous allons maintenant lancer plusieurs containers pour avoir ZABBIX. Pour ce faire, exécutez les commandes suivantes, ou vous pouvez trouver un script après cette partie :

- Créer un réseau Docker pour ZABBIX :
  ```bash
  docker network create --subnet 172.20.0.0/16 --ip-range 172.20.240.0/20 zabbix-net
  ```

- Lancer le serveur MySQL :
  ```bash
  docker run --name mysql-server -t \
               -e MYSQL_DATABASE="zabbix" \
               -e MYSQL_USER="zabbix" \
               -e MYSQL_PASSWORD="zabbix_pwd" \
               -e MYSQL_ROOT_PASSWORD="root_pwd" \
               --network=zabbix-net \
               --restart unless-stopped \
               -d mysql:8.0-oracle \
               --character-set-server=utf8 --collation-server=utf8_bin \
               --default-authentication-plugin=mysql_native_password
  ```

- Lancer le gateway Java pour ZABBIX :
  ```bash
  docker run --name zabbix-java-gateway -t \
               --network=zabbix-net \
               --restart unless-stopped \
               -d zabbix/zabbix-java-gateway:alpine-7.0-latest
  ```

- Lancer le serveur ZABBIX :
  ```bash
  docker run --name zabbix-server-mysql -t \
               -e DB_SERVER_HOST="mysql-server" \
               -e MYSQL_DATABASE="zabbix" \
               -e MYSQL_USER="zabbix" \
               -e MYSQL_PASSWORD="zabbix_pwd" \
               -e MYSQL_ROOT_PASSWORD="root_pwd" \
               -e ZBX_JAVAGATEWAY="zabbix-java-gateway" \
               --network=zabbix-net \
               -p 10051:10051 \
               --restart unless-stopped \
               -d zabbix/zabbix-server-mysql:alpine-7.0-latest
  ```

- Lancer le frontend web ZABBIX avec Nginx :
  ```bash
  docker run --name zabbix-web-nginx-mysql -t \
               -e ZBX_SERVER_HOST="zabbix-server-mysql" \
               -e DB_SERVER_HOST="mysql-server" \
               -e MYSQL_DATABASE="zabbix" \
               -e MYSQL_USER="zabbix" \
               -e MYSQL_PASSWORD="zabbix_pwd" \
               -e MYSQL_ROOT_PASSWORD="root_pwd" \
               --network=zabbix-net \
               -p 80:8080 \
               --restart unless-stopped \
               -d zabbix/zabbix-web-nginx-mysql:alpine-7.0-latest
  ```

#### Vous avez également un script dans le dossier `script` :
  ```bash
  sh script_zabbix.sh
  ```

#### Vous avez également un docker-compose dans le dossier `Docker-Compose/zabbix` :
  ```bash
docker-compose up -d
  ```

- Vous pouvez alors accéder à votre ZABBIX via l'IP de votre machine principale.

---

# Et maintenant pour WordPress

## Voici les commandes !

- Créer un réseau Docker pour WordPress :
  ```bash
  docker network create --subnet 220.20.0.0/16 --ip-range 220.20.240.0/20 wordpress-net
  ```

- Lancer le serveur MySQL pour WordPress :
  ```bash
  docker run --name mysql-server-wordpress -t \
               -e MYSQL_DATABASE="wordpress" \
               -e MYSQL_USER="wordpress" \
               -e MYSQL_PASSWORD="wordpress_pwd" \
               -e MYSQL_ROOT_PASSWORD="root_pwd" \
               --network=wordpress-net \
               --restart unless-stopped \
               -d mysql:8.0-oracle \
               --character-set-server=utf8 --collation-server=utf8_bin \
               --default-authentication-plugin=mysql_native_password
  ```

- Lancer le container WordPress :
  ```bash
  docker run --name wordpress --network wordpress-net -p 8090:80 -d wordpress
  ```

### Vous avez également un script dans le dépôt :
  ```bash
  sh script_wordpress.sh
  ```


#### Vous avez également un docker-compose dans le dossier `Docker-Compose/wordpress` :
  ```bash
docker-compose up -d
  ```

- Vous pouvez ensuite accéder à votre WordPress à l'adresse : `IP:8090` dans votre navigateur web.
```
