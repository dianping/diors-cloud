# Description:
#   Diors Cloud
#
# Dependencies:
#   None
#
# Configuration:
#	None
#
# Commands:
#	diors
#
# Author:
#   Figo

diors_help = """
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
    msg.send "App #{app_name} initiated"
    msg.send "Login Password: TODO"
    msg.send "Now you can type \"ssh dp@#{app_name}.diors.it -p TODO\" in the terminal to login the app server"
  
  # command: diors destroy <app_name>
  robot.respond /diors destroy (\w+)$/i, (msg) ->
    app_name = msg.match[1]
    msg.send "Destroying app #{app_name}...about 15 sec"
    # call API to check privilege
    # call API to destroy the instance
    msg.send "App #{app_name} has been destroyed"
  
  # command: diors list
  robot.respond /diors list$/i, (msg) ->
    # call API to get instance list
  
  # command: diors app <app_name> user add <user_account>
  robot.respond /diors app (\w+) user add ([A-Za-z0-9_@\.]+)$/i, (msg)->
    app_name = msg.match[1]
    user_account = msg.match[2]
    msg.send "Grant access privilege of #{app_name} to #{user_account}"
  
  # command: diors app <app_name> user delete <user_account>
  robot.respond /diors app (\w+) user delete ([A-Za-z0-9_@\.]+)$/i, (msg)->
    app_name = msg.match[1]
    user_account = msg.match[2]
    msg.send "Revoke access privilege of #{app_name} to #{user_account}"
  
  # command: diors app <app_name> user list
  robot.respond /diors app (\w+) user list$/i, (msg)->
    app_name = msg.match[1]
    msg.send "User list of #{app_name} as belows:"
  
  # command: diors app <app_name> up
  robot.respond /diors app (\w+) up$/i, (msg)->
    app_name = msg.match[1]
    msg.send "The app of #{app_name} up..."
    #call API to up
    msg.send "Done"
  
  # command: diors app <app_name> halt
  robot.respond /diors app (\w+) halt$/i, (msg)->
    app_name = msg.match[1]
    msg.send "The app of #{app_name} halting..."
    #call API to halt
    msg.send "Done"

  # command: diors app <app_name> suspend
  robot.respond /diors app (\w+) suspend$/i, (msg)->
    app_name = msg.match[1]
    msg.send "The app of #{app_name} suspending..."
    #call API to suspend
    msg.send "Done"

  # command: diors app <app_name> passwd
  robot.respond /diors app (\w+) passwd$/i, (msg)->
  	app_name = msg.match[1]
  	# call API to get password
  	msg.send "The password of app #{app_name}: TODO"
  	msg.send "Now you can type \"ssh dp@#{app_name}.diors.it -p TODO\" in the terminal to login the app server"
  
  # command: diors app <app_name> bindkey '<key_string>'
  robot.respond /diors app (\w+) bindkey \'(.+)\'$/i, (msg)->
  	app_name = msg.match[1]
  	key_string = msg.match[2]
  	msg.send "Bind key #{key_string} to app #{app_name}"
  	msg.send "Now you can type \"ssh dp@#{app_name}.diors.it\" in the terminal to login the app server"
 
