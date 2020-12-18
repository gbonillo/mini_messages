# README - mini_messages app

## Contexte

Je débutte en Ruby et en RubyOnRails ...  
J'ai plutot l'habitude des applications web mono-bloc même si elles étaient découpées en interne avec les appels d' "api".  
Je n'ai pas anticipé la mise en oeuvre de l'API REST dans les règles de l'art...

J'ai démarré avec une application "web" standard, et non une application "dédiée" d'API REST  

L'application ne répond donc pas aux standards d'une application d'API REST pure (et secure :( ).  
Notamment en terme d'authentification!  
J'aurais aimé recommencer pour monter une application comme ça mais bon...  

J'ai mis en place une authentification ultra simple uniquement pour avoir des utilisateurs connectés pouvant poster des messages... (çe système ne peut être mis en prod :), je pense que les modules "devise" font ça très bien, de toutes façon, si on veut quelque chose de sûr... )  

Le résultat est donc une application avec une interface "web" brut de fonderie mais à peu près fonctionnelle qui permet des appels d'API. Ce n'est pas vraiment le top, ni vraiment ce qui était demandé... 

L'accès à l'api peut se faire en fonction du contexte :
    - dans le navigateur avec une session http en cours (et un user identifié) : accès aux url de l'api avec les extensions ".json"
    - depuis "l'extérieur" (sans session htttp) avec une authentification "http basic" de l'utilisateur... (pas très top :)

Les tests initiaux (web) sont fait avec le module minitest dans le répertoire /test/  
Les tests de l'api sont fait en rspec pour pouvoir générer automatiqment la doc.

## API doc
Voir la doc de l'API dans le dossier doc/api/ : [doc/api/index.html](doc/api/index.html)
Celle-ci a été autogénérée à partir de test de spec avec "rspec_api_documentation"

## General information

### Ruby version : 2.7.2 | Rails version: 6.1.0

### Configuration

ENVIRONMENT VARIABLE needed in a ".env" file :  

pour la version local :

    DB_HOST='localhost'
    DB_USER='user'  
    DB_PWD='password'  

pour la version dans docker :
    
    DB_HOST='db'
    DB_USER='user'  
    DB_PWD='password'  

### Database creation

    rails db:create
    rails db:migrate

### Database initialization

    rails db:seed

### Tests

pour le core et la partie web "html"

    rails test
    rails test:system

pour la partie "API" "json"

    rails spec

### Jobs

Il a un Job pour la purge. 
J'ai mis le gem "arask" pour la config "pseudo cron".


## Docker configuration

Les répertoires suivants sont montés en 'volumes' dans le container docker (voir docker-compose.yml) :
 * `./tmp/db` pour stocker la base de données
 * `./vendor/bundle` pour stocker les gems installés (référence à `/usr/local/bundle`) (si on fait bundle install depuis le Dockerfile on est obliger de rejouer toutes l'install à chaque nouveaux gems ! )

### Docker install

    $ docker-compose build  
    $ docker-compose run --rm web bundle install 
    $ docker-compose run --rm --no-deps web yarn install

initialisation DB

    $ docker-compose run --rm web rails db:create
    $ docker-compose run --rm web rails db:migrate
    $ docker-compose run --rm web rails db:seed

### Docker start / stop
    
    $ docker-compose up
    $ docker-compose down

### Docker bash in running web container

    $ docker-compose exec web bash

