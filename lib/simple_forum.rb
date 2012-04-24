require 'bb-ruby'
require 'bb-ruby/bb-ruby'
require 'simple_forum/configuration'

module SimpleForum

  mattr_accessor :layout
  @@layout = "simple_forum"

  mattr_accessor :main_application_name
  @@main_application_name = "My Application"

  mattr_accessor :minutes_for_edit_post
  @@minutes_for_edit_post = 15

  mattr_accessor :minutes_for_delete_post
  @@minutes_for_delete_post = 15

  def self.user_class(&blk)
    Configuration.user_class(&blk)
  end

  #default :user_class implementation
  user_class do
    User
  end

  def self.authenticated_user(&blk)
    Configuration.authenticated_user(&blk)
  end

  #default :authenticated_user implementation
  authenticated_user do
    current_user
  end

  def self.user_authenticated?(&blk)
    Configuration.user_authenticated?(&blk)
  end

  #default :user_authenticated? implementation
  user_authenticated? do
    user_signed_in?
  end

  def self.invoke(symbol)
    ::SimpleForum::Configuration.invoke(symbol)
  end

  ::SimpleForum::Configuration.requires :user_class, :authenticated_user, :user_authenticated?

  # Yield self on setup for nice config blocks
  def self.setup
    yield self
  end

  require File.expand_path("../../app/models/simple_forum.rb", __FILE__)
end

require 'simple_forum/engine'