require 'digest/md5'

class Key < ActiveRecord::Base
  attr_accessible :pub_key, :title
  attr_accessor :current_machine

  validates :pub_key, presence: true, length: { within: 0..5000 }, format: { :with => /ssh-.{3} / }, uniqueness: true
  validates :user_id, presence: true
  validates :identifier, presence: true
  validate :fingerprintable_key

  belongs_to :user

  has_and_belongs_to_many :machines

  before_validation do
    self.pub_key.try(:strip!)
    self.identifier = Digest::MD5.hexdigest(self.pub_key)
  end

  after_create do
    update_attributes(title: "key-#{user.email[/.*(?=@)/]}-#{id}") if title.blank?
  end

  def fingerprintable_key
    return true unless pub_key # Don't test if there is no key.

    file = Tempfile.new('key_file')
    begin
      file.puts pub_key
      file.rewind
      fingerprint_output = `ssh-keygen -lf #{file.path} 2>&1` # Catch stderr.
    ensure
      file.close
      file.unlink # deletes the temp file
    end
    errors.add(:pub_key, "can't be fingerprinted") if $?.exitstatus != 0
  end

end
