usage: diors <command> [<args>]

command list:
   diors help
   diors init <app-name> 	
   diors destroy <app-name>
   diors list
   diors assign <app-name> <user-account>
   diors instance <app-name> up
   diors instance <app-name> halt
   diors instance <app-name> suspend
   diors login <app-name> bindkey <key-string>
   diors login <app-name> password

instance login:
   login by ssh-key:
      ssh dp@<app-name>.diors.it
   login by passwd:
      ssh dp@<app-name>.diors.it -p <passwd>      
