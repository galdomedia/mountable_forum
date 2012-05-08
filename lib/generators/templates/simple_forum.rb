SimpleForum.setup do |config|
  # The layout for simple forum views. The default is 'simple_forum'.
  #config.layout = "application"

  # The name of yours application. It will be shown as root in forum breadcrumbs. The default is 'My application'.
  #config.main_application_name = "My application name"

  # How long users can edit theirs posts. You can set 0 if users should not edit theirs posts. The default is 15.
  #config.minutes_for_edit_post = 5

  # How long users can delete theirs posts. You can set 0 if users should not delete theirs posts. The default is 15.
  #config.minutes_for_delete_post = 5

  #config.sign_in_path = :new_user_session

  #config.sign_out_path = :destroy_user_session

  # User model class. The default is User
  #config.user_class do
  #  User
  #end

  # default :authenticated_user implementation. The default is current_user
  #config.authenticated_user do
  #  current_user
  #end

  # default :user_authenticated? implementation. The default is user_signed_in?
  #config.user_authenticated? do
  #  user_signed_in?
  #end

  #default :forum_admin? implementation
  #config.forum_admin? do
  #  current_user && current_user.is_admin?
  #end

end