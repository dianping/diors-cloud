usage: diors <command> [<args>]

command list:
   diors help

   diors init <app_name> <box_type>
   diors destroy <app_name>
   diors list

   diors app <app_name> user add <user_account>
   diors app <app_name> user delete <user_account>
   diors app <app_name> user list

   diors app <app_name> up
   diors app <app_name> halt
   diors app <app_name> suspend

   diors app <app_name> bindkey <key_string>
   diors app <app_name> passwd

instance ssh:
   by ssh-key:
      ssh dp@<app_name>.diors.it
   by passwd:
      ssh dp@<app_name>.diors.it -p <passwd>