class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :validatable
  #  :recoverable, :rememberable, :trackable

  def login
    "Login-#{id}"
  end
end
