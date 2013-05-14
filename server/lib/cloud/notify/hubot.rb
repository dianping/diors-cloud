require 'rest_client'

module Cloud
  module Notify
    module Hubot
      def self.send(email, message)
        RestClient.post Settings.diors.hubot.callback_url, email: email, message: message 
      end
    end
  end
end
