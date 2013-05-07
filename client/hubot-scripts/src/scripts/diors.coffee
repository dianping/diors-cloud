
diors_help = """
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
      """

module.exports = (robot) ->
  robot.respond /diors( help)?$/i, (msg) ->
    msg.send diors_help
    
  robot.respond /diors init (\w+)$/i, (msg) ->
    name = msg.match[1]
    msg.send "Initiating app #{name}...about 30 sec"
    # call API to create an instance
    # TODO
    # call API to bind DNS
    # TODO
    msg.send "Instance #{name}.diors.it initiated"
    msg.send "Login Password: TODO"
    msg.send "Now you can use type \"ssh dp@#{name}.diors.it -p TODO\" in the terminal to login the instance"
  
  robot.respond /diors destroy (\w+)$/i, (msg) ->
    name = msg.match[1]
    user_name = msg.message.user.name
    user_domain = msg.message.user.domain
    user_email = "#{user_name}@#{user_domain}"
    msg.send "Destroying app #{name}...about 15 sec"
    # call API to check privilege
    # call API to destroy the instance
    msg.send "App #{name} has been destroyed"
    msg.send "Thank you for using Diors Cloud"
    
    
  

  