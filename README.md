Bootstrap
=========

Bootstraps a new Ubuntu server, currently assumes Ubuntu 13.04.

To bootstrap a new server, run this command (as a user that has sudo access)

    curl -s https://raw.github.com/exodusbv/bootstrap/master/bootstrap.sh > bootstrap && /bin/bash bootstrap

To prepare the MySQL database for a new application, run

    /usr/bin/create-database
