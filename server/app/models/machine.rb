class Machine < ActiveRecord::Base
  attr_accessible :ip, :status, :uuid
  
  belongs_to :project
end
