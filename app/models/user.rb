class User < ApplicationRecord
  after_initialize :init
  
  enum role: {
    super_admin: "super_admin",
    admin: "admin",
    supervisor: "supervisor",
    planner: "planner",
    method_engineer: "method_engineer",
    quality: "quality",
    station: "station"
  }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :registerable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :site
  has_many :accesses
  has_many :contracts, :through => :accesses
  has_many :stations, :through => :contracts, :source => :stations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :username, presence: true
  validates :suspended, :inclusion => { :in => [true, false] }
  
  attr_accessor :ignore_password
  validates :password,
    presence: true,
    length: { :minimum => 8 },
    format: { with: /(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}/ },
    unless: -> { self.ignore_password }
    
  # built in devise function to check for "active" state of the model
  def active_for_authentication?
    super and !self.suspended?
  end

  def init
    self.suspended = false if self.suspended.nil?
  end
end
