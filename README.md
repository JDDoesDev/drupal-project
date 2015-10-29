# Composer template for Drupal projects

[![Build Status](https://travis-ci.org/drupal-composer/drupal-project.svg?branch=8.x)](https://travis-ci.org/drupal-composer/drupal-project)

This project template should provide a kickstart for managing your site
dependencies with [Composer](https://getcomposer.org/).

If you want to know how to use it as replacement for
[Drush Make](https://github.com/drush-ops/drush/blob/master/docs/make.md) visit
the [Documentation on drupal.org](https://www.drupal.org/node/2471553).

## Usage

First you need to [install composer](https://getcomposer.org/doc/00-intro.md#installation-linux-unix-osx).

> Note: The instructions below refer to the [global composer installation](https://getcomposer.org/doc/00-intro.md#globally).
You might need to replace `composer` with `php composer.phar` (or similar) for your setup.

After that you can create the project:

```
composer create-project drupal-composer/drupal-project:8.x-dev some-dir --stability dev --no-interaction
```

With `composer require ...` you can download new dependencies to your installation.

```
cd some-dir
composer require drupal/devel:8.*
```

## What does the template do?

When installing the given `composer.json` some tasks are taken care of:

* Drupal will be installed in the `docroot`-directory.
* Autoloader is implemented to use the generated composer autoloader in `vendor/autoload.php`,
  instead of the one provided by Drupal (`docroot/vendor/autoload.php`).
* Modules (packages of type `drupal-module`) will be placed in `docroot/modules/contrib/`
* Theme (packages of type `drupal-theme`) will be placed in `docroot/themes/contrib/`
* Profiles (packages of type `drupal-profile`) will be placed in `docroot/profiles/contrib/`
* Creates default writable versions of `settings.php` and `services.yml`.
* Creates `sites/default/files`-directory.
* Latest version of drush is installed locally for use at `vendor/bin/drush`.
* Latest version of DrupalConsole is installed locally for use at `vendor/bin/console`.

## Updating Drupal Core

Updating Drupal core is a two-step process.

1. Update the version number of `drupal/core` in `composer.json`.
1. Run `composer update drupal/core`.
1. Run `./scripts/drupal/update-scaffold` to update files in the `docroot` directory.
   This will update `docroot` with whatever the latest Drupal 8 release is. Review
   the files for any changes and restore any customizations to `.htaccess` or
   `robots.txt`.
1. Commit everything all together in a single commit, so `docroot` will remain in
   sync with the `core` when checking out branches or running `git bisect`.

## Generate composer.json from existing project

With using [the "Composer Generate" drush extension](https://www.drupal.org/project/composer_generate)
you can now generate a basic `composer.json` file from an existing project. Note
that the generated `composer.json` might differ from this project's file.


## FAQ

### Should I commit the contrib modules I download

Composer recommends **no**. They provide [argumentation against but also workrounds if a project decides to do it anyway](https://getcomposer.org/doc/faqs/should-i-commit-the-dependencies-in-my-vendor-directory.md).

### How do I use this on Acquia cloud?

Add this to your `settings.php` before deploying to Acquia Cloud. Replace `AH_SITE_GROUP` with the name of your site
group in Acquia Cloud.

```php
<?php

// On Acquia Cloud, this include file configures Drupal to use the correct
// database in each site environment (Dev, Stage, or Prod). To use this
// settings.php for development on your local workstation, set $db_url
// (Drupal 5 or 6) or $databases (Drupal 7 or 8) as described in comments above.
if (file_exists('/var/www/site-php')) {

  // As of 29 October 2015, Acquia Cloud does not support release candidates of Drupal 8,
  // so we must define `conf_path` function which was removed between beta15 and RC1.
  if (!function_exists('conf_path')) {
    function conf_path() {
      $request = \Symfony\Component\HttpFoundation\Request::createFromGlobals();
      return \Drupal\Core\DrupalKernel::findSitePath($request, FALSE);
    }
  }
  require('/var/www/site-php/AH_SITE_GROUP/AH_SITE_GROUP-settings.inc');
}
```
