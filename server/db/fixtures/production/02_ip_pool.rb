require 'ipaddr'
low = IPAddr.new('192.168.212.51')
high = IPAddr.new('192.168.212.80')
(low..high).each do |ip|
  IpPool.create(ip: ip.to_s)
end
