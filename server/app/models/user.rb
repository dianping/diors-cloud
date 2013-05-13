require 'securerandom'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  has_and_belongs_to_many :projects
  has_many :owner_projects, class_name: 'Project', foreign_key: 'owner_id'
  has_many :keys

  before_create :initialize_user

  def add_key(pub_key)
    key = Key.new(pub_key: pub_key)
    key.user = self
    key.save ? key : nil
  end

  private
  def initialize_user
    self.name = self.email.split('@').first if self.email.present? && self.name.blank?
    self.token = SecureRandom.hex(8)
  end

end
