# How to use it ?

The docker-compose.yml file is used to build and run limesurvey in the current workspace.
This docker image intended for development usage.

Structure des dossiers
www/LimeSurvey/docker_limesurvey
www/LimeSurvey/LimeSurvey

First times create volume for maria db

    mkdir -p /opt/data/limesurvey
    
    docker volume create --driver local \
        --opt type=none \
        --opt device=/opt/data/limesurvey \
        --opt o=bind mariadb-limesurvey

And then, you can run :

        docker-compose up

### .env file

Then, create a .env file all environment variables, including the root password, as follows (the password is raw after the equal sign) :

       `MYSQL_ROOT_PASSWORD=root`

PLEASE, do apply secure permissions to this .env file (in **production**):

        chmod 600 .env


### Run compose

This will run 4 container Docker : limesurvey, MariaDB, PhpMyAdmin and GreenMail.

On first install set
        
            limesurvey-mariadb
        
as database host

The URL to go to the LimeSurvey is :

        http://0.0.0.0

The URL to go to PhpMyAdmin is (login/password is root/root) :

        http://0.0.0.0:8080

In Green mail : Create user
http://0.0.0.0:6081/#post-/api/user

RoundCube with the email account you've created in Greenmail

http://0.0.0.0:6082
