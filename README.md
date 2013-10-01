Airdrop
=======
Extremely simple service manager + upgrade system for simple docker services.

This package is designed to be ran from the airdrop image, which has all
dependencies installed.

Dev dependencies:
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

