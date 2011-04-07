require 'abstract_auth'

module SimpleForum

  AbstractAuth.setup do |config|
    config.requires :user_class

    #default authenticated_user implementation
    config.implement :user_class do
      User
    end

    config.requires :authenticated_user

    #default authenticated_user implementation
    config.implement :authenticated_user do
      current_user
    end

    config.requires :user_authenticated?

    #default authenticated_user implementation
    config.implement :user_authenticated? do
      user_signed_in?
    end
  end

  mattr_accessor :route_namespace
  @@route_namespace = "forum"

  mattr_accessor :layout
  @@layout = "simple_forum"

  # Yield self on setup for nice config blocks
  def self.setup
    yield self
  end

end

require 'simple_forum/engine' if defined?(Rails)