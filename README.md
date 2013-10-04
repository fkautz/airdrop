Airdrop
=======
Extremely simple service manager + upgrade system for simple docker services.

This package is designed to be ran from the airdrop image, which has all
dependencies installed.

Core Concepts
-------------
Airdrop is a simple orchestration system for starting, upgrading,
backing up, and stopping service. There are three primary commands an
airdrop user should be familiar with.

start, stop, backup

Workflow:

airdrop.rb start my/webservice # pulls my/webservice and executes it
airdrop.rb stop my/webservice # stops the my/webservice container
airdrop.rb backup my/webservice # backs up the my/webservice container. 

Airdrop also maintains two directories per service for preserving state.

```
[guest] => [host]
/data => /docker/my/webservice/data
/var/log => /docker/my/webservice/logs
```

Limitations
-----------
Each image may only have one container. This limitation will eventually
be lifted with the use of named slots. 

Start parameters must be specified internally. This limitation will be
lifted through the use of storing arguments, tied to named slots.

Dev dependencies
----------------
* sqlite3 + headers
* docker
* ruby (should work with 1.9 and above, tested with 1.9.1 from ubuntu)


Public Commands
---------------
Airdrop commands:
  airdrop.rb backup SERVICE            # backups data from a service
  airdrop.rb connect                   # connect to the database
  airdrop.rb help [COMMAND]            # Describe available commands or one specific command
  airdrop.rb migrate                   # Migrates airdrop database to latest version
  airdrop.rb start SERVICE PARAMETERS  # starts a service
  airdrop.rb status                    # shows running containers
  airdrop.rb stop SERVICE              # stops a service

