class IpPool < ActiveRecord::Base
  attr_accessible :ip, :status

  STATUS = {
    "available" => 1,
    "used" => 0
  }

  scope :available, -> { where(status: STATUS["available"]) }
  scope :used, -> { where(status: STATUS["used"]) }

  class << self
    def assign
      IpPool.transaction do
        ip = IpPool.available.lock(true).first
        raise Cloud::NoIpAvailableError.new if ip.blank?
        ip.to_used if ip.present?
        ip
      end
    end
  end

  def to_used
    update_attributes(status: 0)
  end

end
