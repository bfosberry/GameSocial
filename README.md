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

Gamers are no stranger to services like Steam, XBox Live, and PlayStation Network (PSN).  GameSocial isn't much different.  Well, ok, it is slightly.  The difference is GameSocial is OpenSource, and proposed to be a "cross-platform" hub for gaming network.  GameSocial is the all-the-thing meme Gamers have been waiting for.  Along with views into who's playing what game(s), scores, chat, co-op invites, and notifications; the plan is to also be able to set up scheduled events, tournament ladders, and much more.

GameSocial will be your one-stop shop for managing and socializing your gaming experience.  No more pre-planning to meet your friend(s) on system 'X'.  Simply load up GameSocial on your Smart Phone, Laptop, Nearby Desktop, Game Rig you are on, RaspPi, etc.  Now, play that XBox game, and when a friend sends you a request to play a PC game, choose to switch over or not...  Simple!

----

## Whats Next?

Take a look at our [alpha release page](https://github.com/bfosberry/GameSocial/wiki/Alpha-release) for info on what features are in the pipeline atm.

----

## Getting started

### Prerequisites

Before geting started make sure you have the following

* ruby-1.9.3
* redis

### Setup

* Configure database.yml
* Get your steam api key [here](http://steamcommunity.com/dev/apikey)
* Create secret.yml, use secret.yml.example as a template
* Run rake db:create && rake db:migrate

### Running the app

* Run the server with "rails s"
* Run sidekiq with "sidekiq -C config/myapp_sidekiq.yml"
* Configure the cron tasks with "whenever -w"

### Tools

There are a couple of rake tasks which can help with managing application data.

* rake sync:location: Synchronize the location of all users
* rake sync:all :Syncronize all user data

----

## Running instances

Staging: [Heroku](http://dev-gamesocial.herokuapp.com/)
 
 Staging has a single worker thread and does not handle the large number of tasks around syncing all locations well, the worker thread may block.