
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
  
  user_email = (msg) -> "#{msg.message.user.name}@#{msg.message.user.domain}"
  
  # command: diors help	
  robot.respond /diors( help)?$/i, (msg) ->
    msg.send diors_help
  
  # command: diors init <app_name> <box_type>
  robot.respond /diors init (\w+)( ubuntu| centos)?$/i, (msg) ->
    app_name = msg.match[1]
    box_type = if msg.match[2] then msg.match[2].trim() else "ubuntu"
    msg.send "Initiating app #{app_name} with #{box_type} image...about 30 sec"
    # call API to create an instance
    # TODO
    # call API to bind DNS
    # TODO
    msg.send "Instance #{app_name}.diors.it initiated"
    msg.send "Login Password: TODO"
    msg.send "Now you can use type \"ssh dp@#{app_name}.diors.it -p TODO\" in the terminal to login the instance"
  
  robot.respond /diors destroy (\w+)$/i, (msg) ->
    app_name = msg.match[1]
    msg.send "Destroying app #{app_name}...about 15 sec"
    # call API to check privilege
    # call API to destroy the instance
    msg.send "App #{app_name} has been destroyed"
    msg.send "Thank you for using Diors Cloud"
  
  robot.respond /diors list$/i, (msg) ->
  	


    
    
    
  

  