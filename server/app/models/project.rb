require 'fileutils'
require 'securerandom'
require 'pathname'

class Project < ActiveRecord::Base
  attr_accessible :name, :slug, :token

  validates_presence_of :name, :owner_id
  validates_format_of :name, with: /\w+/
  validates_uniqueness_of :name

  has_one :machine
  belongs_to :owner, class_name: 'User'
  has_and_belongs_to_many :users

  extend FriendlyId
  friendly_id :name, use: :slugged

  before_create :initialize_token_and_user
  after_create :mkdir
  after_destroy :rmdir

  class << self
    def create_with_owner(name, user)
      project = Project.new(name: name)
      project.owner = user
      project.save
      project
    end
  end

  def path
    @path ||= Pathname.new("#{Settings.diors.root_path}/#{slug}")
  end

  def shared_path
    path.join("shared")
  end

  def clear
    ActiveRecord::Base.transaction do
      if machine.present?
        # destroy self after withdraw machine successfully when machine is available
        machine.withdraw and self.destroy
      else
        self.destroy
      end
    end
  end

  def has_member?(user)
    users.exists?(user.id)
  end  

  def domain
    "#{slug}.diors.it"
  end

  private
  def mkdir
    FileUtils.mkdir_p(path)
    FileUtils.mkdir_p(shared_path)
  end

  def rmdir
    FileUtils.rm_rf(path)
  end

  def initialize_token_and_user
    self.token = SecureRandom.hex(8)
    self.users << self.owner
  end

end
