usage: diors <command> [<args>]

command list:
   diors help

   diors init <app_name> <box_type>
   diors destroy <app_name>
   diors list

   diors user add <app_name> <user_account>
   diors user delete <app_name> <user_account>
   diors user list <app_name>

   diors instance <app_name> up
   diors instance <app_name> halt
   diors instance <app_name> suspend

   diors ssh <app_name> key <key_string>
   diors ssh <app_name> password

instance ssh:
   by ssh-key:
      ssh dp@<app_name>.diors.it
   by passwd:
      ssh dp@<app_name>.diors.it -p <passwd>      
