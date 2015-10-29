#!/bin/sh

# Prepare the settings file for installation
if [ ! -f docroot/sites/default/settings.php ]
  then
    cp docroot/sites/default/default.settings.php docroot/sites/default/settings.php
    chmod 777 docroot/sites/default/settings.php
fi

# Prepare the services file for installation
if [ ! -f docroot/sites/default/services.yml ]
  then
    cp docroot/sites/default/default.services.yml docroot/sites/default/services.yml
    chmod 777 docroot/sites/default/services.yml
fi

# Prepare the files directory for installation
if [ ! -d docroot/sites/default/files ]
  then
    mkdir -m777 docroot/sites/default/files
fi
