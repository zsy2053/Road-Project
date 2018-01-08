class User < ApplicationRecord
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
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :site
  has_many :accesses
  has_many :contracts, :through => :accesses
  has_many :stations, :through => :contracts, :source => :stations
  validates :email, presence: true
  validates :username, presence: true
  validates :password,
    presence: true,
    length: { :minimum => 8 },
    format: { with: /(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}/ }
end
