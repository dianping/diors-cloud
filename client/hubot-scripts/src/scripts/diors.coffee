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

   diors init <app_name>
   diors destroy <app_name>

   diors app <app_name> user add <user_account>
   diors app <app_name> user delete <user_account>
   diors app <app_name> user list

   diors app <app_name> up
   diors app <app_name> halt
   diors app <app_name> suspend
   diors app <app_name> resume
   diors app <app_name> state

   diors app <app_name> bindkey <key_string>
   diors app <app_name> passwd <password>

instance ssh:
   by ssh-key:
      ssh dp@<app_name>.diors.it
   by passwd:
      ssh dp@<app_name>.diors.it -p <passwd>      
      """

module.exports = (robot) ->
  
  user_email = (msg) -> "#{msg.message.user.name}@#{msg.message.user.domain}"
  diors_api_url = "#{process.env.DIORS_API_URL}/api/v1/app"
  diors_api_token = process.env.DIORS_TOKEN
  format = (user) ->
    "#{user.email} is #{user.role} of this app."

  # command: diors help	
  robot.respond /diors( help)?$/i, (msg) ->
    msg.send diors_help
  
  # command: diors init <app_name>
  robot.respond /diors init (\w+)$/i, (msg) ->
    app_name = msg.match[1]
    msg.send "Initiating app #{app_name}..."
    msg.http("#{diors_api_url}/#{app_name}/init")
      .query({'hubot_token': diors_api_token, 'email': user_email(msg)})
      .get() (err, res, body) ->
        msg.send JSON.parse(body).message
  
  # command: diors destroy <app_name>
  robot.respond /diors destroy (\w+)$/i, (msg) ->
    app_name = msg.match[1]
    msg.send "Destroying app #{app_name}"
    msg.http("#{diors_api_url}/#{app_name}/destroy")
      .query({'hubot_token': diors_api_token, 'email': user_email(msg)})
      .get() (err, res, body) ->
        msg.send JSON.parse(body).message
  
  # command: diors app <app_name> user add <user_account>
  robot.respond /diors app (\w+) user add ([A-Za-z0-9_@\.]+)$/i, (msg) ->
    app_name = msg.match[1]
    user_account = msg.match[2]
    msg.http("#{diors_api_url}/#{app_name}/user/add")
      .query({'hubot_token': diors_api_token, 'email': user_email(msg), 'user_account': user_account})
      .get() (err, res, body) ->
        msg.send JSON.parse(body).message
  
  # command: diors app <app_name> user delete <user_account>
  robot.respond /diors app (\w+) user delete ([A-Za-z0-9_@\.]+)$/i, (msg) ->
    app_name = msg.match[1]
    user_account = msg.match[2]
    msg.http("#{diors_api_url}/#{app_name}/user/delete")
      .query({'hubot_token': diors_api_token, 'email': user_email(msg), 'user_account': user_account})
      .get() (err, res, body) ->
        msg.send JSON.parse(body).message
  
  # command: diors app <app_name> user list
  robot.respond /diors app (\w+) user list$/i, (msg) ->
    app_name = msg.match[1]
    msg.http("#{diors_api_url}/#{app_name}/user/list")
      .query({'hubot_token': diors_api_token, 'email': user_email(msg)})
      .get() (err, res, body) ->
        data = JSON.parse(body)
        message = if data.status == 200 then (format user for user in data.users).join('\n') else data.message
        msg.send message
  
  # command: diors app <app_name> up
  robot.respond /diors app (\w+) up$/i, (msg) ->
    app_name = msg.match[1]
    msg.send "Start the machine of #{app_name}..."
    msg.http("#{diors_api_url}/#{app_name}/inst/up")
      .query({'hubot_token': diors_api_token, 'email': user_email(msg)})
      .get() (err, res, body) ->
        msg.send JSON.parse(body).message
  
  # command: diors app <app_name> halt
  robot.respond /diors app (\w+) halt$/i, (msg) ->
    app_name = msg.match[1]
    msg.send "Turn of the machine of #{app_name}..."
    msg.http("#{diors_api_url}/#{app_name}/inst/halt")
      .query({'hubot_token': diors_api_token, 'email': user_email(msg)})
      .get() (err, res, body) ->
        msg.send JSON.parse(body).message

  # command: diors app <app_name> suspend
  robot.respond /diors app (\w+) suspend$/i, (msg) ->
    app_name = msg.match[1]
    msg.send "Suspend the machine of #{app_name}..."
    msg.http("#{diors_api_url}/#{app_name}/inst/suspend")
      .query({'hubot_token': diors_api_token, 'email': user_email(msg)})
      .get() (err, res, body) ->
        msg.send JSON.parse(body).message

  # command: diors app <app_name> resume 
  robot.respond /diors app (\w+) resume/i, (msg) ->
    app_name = msg.match[1]
    msg.send "Resume the machine of #{app_name}..."
    msg.http("#{diors_api_url}/#{app_name}/inst/resume")
      .query({'hubot_token': diors_api_token, 'email': user_email(msg)})
      .get() (err, res, body) ->
        msg.send JSON.parse(body).message

  # command: diors app <app_name> state
  robot.respond /diors app (\w+) (state|status)/i, (msg) ->
    app_name = msg.match[1]
    msg.http("#{diors_api_url}/#{app_name}/inst/state")
      .query({'hubot_token': diors_api_token, 'email': user_email(msg)})
      .get() (err, res, body) ->
        msg.send JSON.parse(body).message

  # command: diors app <app_name> passwd
  robot.respond /diors app (\w+) passwd (\w+)$/i, (msg) ->
    app_name = msg.match[1]
    password = msg.match[2]
    msg.http("#{diors_api_url}/#{app_name}/ssh/passwd")
      .query({'hubot_token': diors_api_token, 'email': user_email(msg), 'password': password})
      .get() (err, res, body) ->
        msg.send JSON.parse(body).message
  
  # command: diors app <app_name> bindkey '<key_string>'
  robot.respond /diors app (\w+) bindkey \'(.+)\'$/i, (msg) ->
    app_name = msg.match[1]
    key_string = msg.match[2]
    msg.http("#{diors_api_url}/#{app_name}/ssh/bindkey")
      .query({'hubot_token': diors_api_token, 'email': user_email(msg), 'key_string': key_string})
      .get() (err, res, body) ->
        msg.send JSON.parse(body).message
 
  robot.router.post "/hubot/diors/callback", (req, res) ->
    user = robot.brain.userForId req.body.email
    robot.send {user: user}, req.body.message
    res.end "ok"
