class User < ApplicationRecord
  after_initialize :init

  enum role: {
    super_admin: "super_admin",
    admin: "admin",
    supervisor: "supervisor",
    planner: "planner",
    method_engineer: "method_engineer",
    quality: "quality",
    station: "station",
    api_trackware: "api_trackware",
    andon: "andon"
  }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :registerable, :timeoutable, :validatable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable

  belongs_to :site
  has_many :accesses
  accepts_nested_attributes_for :accesses
  has_many :contracts, :through => :accesses
  has_many :stations, :through => :contracts, :source => :stations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :username, presence: true, uniqueness: true
  validates :employee_id, presence: true, uniqueness: true
  validates :suspended, :inclusion => { :in => [true, false] }
  validates :site_name_text, presence: true

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
