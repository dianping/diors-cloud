require 'net/http'

module Cloud
  module Helpers
    # you may add the dns #{Settings.diors.dns_service.ip}
    def bind_ip(ip,domain)
      uri = URI("http://#{Settings.diors.dns_service.ip}:#{Settings.diors.dns_service.port}/addname")
      params = { :rdata => "#{ip}", :name => "#{domain}" }
      uri.query = URI.encode_www_form(params)
      res = Net::HTTP.get_response(uri)
      res.code == "200" ? true : false
    end  

    def release_ip(ip,domain)
      uri = URI("http://#{Settings.diors.dns_service.ip}:#{Settings.diors.dns_service.port}/delname")
      params = { :rdata => "#{ip}", :name => "#{domain}" }
      uri.query = URI.encode_www_form(params)
      res = Net::HTTP.get_response(uri)
      res.code == "200" ? true : false
    end

  end  
end