require 'fileutils'
require 'securerandom'

class Project < ActiveRecord::Base
  attr_accessible :name, :slug, :token

  validates_presence_of :name, :owner_id
  validates_format_of :name, with: /\w+/

  has_one :machine
  belongs_to :owner, class_name: 'User'
  has_and_belongs_to_many :users

  extend FriendlyId
  friendly_id :name, use: :slugged

  before_create :initialize_token_and_user
  after_create :mkdir

  def path
    @path ||= "#{Settings.diors.vm.root_path}/#{slug}"
  end

  private
  def mkdir
    FileUtils.mkdir_p(path)
  end

  def initialize_token_and_user
    self.token = SecureRandom.hex(8)
    self.users << self.owner
  end

end
