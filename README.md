# README - mini_messages app

## General information

* Ruby version : 2.7.2

* System dependencies : ?

* Configuration

ENVIRONMENT VARIABLE needed in a ".env" file :

    DB_USER='user'  
    DB_PWD='password'  

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Docker configuration

Les répertoires suivants sont montés en 'volumes' dans le container docker (voir docker-compose.yml) :
 * `./tmp/db` pour stocker la base de données
 * `./vendor/bundle` pour stocker les gems installés (référence à `/usr/local/bundle`) (si on fait bundle install depuis le Dockerfile on est obliger de rejouer toutes l'install à chaque nouveaux gems ! )

## Docker install

    $ docker-compose build  
    $ docker-compose run --rm web bundle install 
    $ docker-compose run --rm --no-deps web yarn install

initialisation DB

    $ docker-compose run --rm web rails db:create
    $ docker-compose run --rm web rails db:migrate
    $ docker-compose run --rm web rails db:seed

## Docker start / stop
    
    $ docker-compose up
    $ docker-compose down

## Docker bash in running web wontainer

    $ docker-compose exec web bash