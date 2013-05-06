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

  before_create :initialize_token

  private
  def initialize_token
    self.token = SecureRandom.hex(8)
  end
end
