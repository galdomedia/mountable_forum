class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :validatable
  #  :recoverable, :rememberable, :trackable

  def name
    "Login-#{id}"
  end

  def is_admin?
    /admin@/ === email
  end

end
