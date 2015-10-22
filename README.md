GameSocial
==

**Socialize your gaming experience.**

> Written with [StackEdit](http://benweet.github.io/stackedit/).  
> Authored By: Dale Bracey - [@IRTermite](https://twitter.com/IRTermite)  
> Initial Development By: Brendan Fosberry | Gus Ireland

Spoon Programming Applied: http://www.youtube.com/watch?v=dYBjVTMUQY0

Play around in our development environment [here](http://dev-gamesocial.herokuapp.com/)   
If you are interested in what we're doing please feel free to [contribute](https://github.com/bfosberry/GameSocial/wiki/Contributing).

To stay up to date on what we are doing join our [Google Group](https://groups.google.com/forum/#!forum/hackgamesocial)  

----


## Overview

Gamers are no stranger to services like Steam, XBox Live, and PlayStation Network (PSN). GameSocial isn't much different.  Well, ok, it is slightly.  The difference is GameSocial is OpenSource, and proposed to be a "cross-platform" hub for gaming network.  GameSocial is the all-the-thing meme Gamers have been waiting for.  Along with views into who's playing what game(s), scores, chat, co-op invites, and notifications; the plan is to also be able to set up scheduled events, tournament ladders, and much more.

GameSocial will be your one-stop shop for managing and socializing your gaming experience.  No more pre-planning to meet your friend(s) on system 'X'.  Simply load up GameSocial on your Smart Phone, Laptop, Nearby Desktop, Game Rig you are on, RaspPi, etc.  Now, play that XBox game, and when a friend sends you a request to play a PC game, choose to switch over or not...  Simple!

For details on how to use app, check out the [Wiki](https://github.com/bfosberry/GameSocial/wiki) and the [Github pages site](http://bfosberry.github.io/GameSocial).

----

## Whats Next?

Take a look at the [beta relase milestone](https://github.com/bfosberry/GameSocial/milestones/Beta%20release) for info on what features are in the pipeline atm.

----

## Getting started

### Prerequisites

Before geting started make sure you have the following

* ruby-2.2.3
* redis
* sqllite or other DB
* A steam API key
* Google API creds

### Config

Set the following values in your environment, you still have limited functionality with only some of these values set.

```
CALENDAR_PASSWORD:           XXXXXXXXXXXXXX
CALENDAR_USERNAME:           XXXXXXXXXXXXXX
GOOGLE_CALENDAR_CLIENT_ID:   XXXXXXXXXXXXXX
GOOGLE_CALENDAR_ID:          XXXXXXXXXXXXXX
GOOGLE_CLIENT_ID:            XXXXXXXXXXXXXX
GOOGLE_CLIENT_SECRET:        XXXXXXXXXXXXXX
GOOGLE_KEY:                  -----BEGIN RSA PRIVATE KEY-----
XXXXXXX
-----END RSA PRIVATE KEY-----
GOOGLE_KEY_SECRET:           mysecret
SIDEKIQ_PASSWORD:            mypass
SIDEKIQ_USERNAME:            myuser
SMTP_PASSWORD:               XXXXXX
SMTP_PORT:                   587
SMTP_SERVER:                 smtp.gmail.com
SMTP_USERNAME:               XXXXXX
STEAM_API_KEY:               XXXXXX
```

### Setup

* Configure database.yml
* Get your steam api key [here](http://steamcommunity.com/dev/apikey)
* Create secret.yml, use secret.yml.example as a template
* Run rake db:create && rake db:migrate

### Running the app

* Run the server with "rails s"
* Run sidekiq
* Configure the cron tasks with "whenever -w"

### Tools

There are a couple of rake tasks which can help with managing application data.

* rake sync:location: Synchronize the location of all users
* rake sync:all :Syncronize all user data
* rake gc:alerts and rake gc:locations will clean up the db

----

## Running instances

There are two live environments you can use

* [Staging](http://dev.gamesocial.co)
* [Production](http://www.gamesocial.co)