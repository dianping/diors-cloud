class IpPool < ActiveRecord::Base
  attr_accessible :ip, :status

  STATUS = {
    "avaliable" => 1,
    "used" => 0
  }
end
