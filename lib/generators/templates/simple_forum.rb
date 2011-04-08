SimpleForum.setup do |config|
# The namespace that you would like to use for the routes. The default is 'forum'.
#     config.route_namespace = 'my_custom_route_namespace'

# The layout for simple forum views. The default is 'simple_forum'.
#     config.layout = "application"

# The name of yours application. It will be shown as root in forum breadcrumbs. The default is ''My application'.
#     config.root_application_name = "My application name"

# How long users can edit theirs posts. You can set 0 if users should not edit theirs posts. The default is '15.
#     config.minutes_for_edit_post = 5

# How long users can delete theirs posts. You can set 0 if users should not delete theirs posts. The default is '15.
#     config.minutes_for_delete_post = 5

end

# AbstractAuth Implementations

#aktualnie zalogowany użytkownik. Default: current_user
#AbstractAuth.implement :authenticated_user do
# current_user
#end

#Czy użytkownik jest zalogowany. Default: user_signed_in?
#AbstractAuth.implement :user_authenticated? do
# user_signed_in?
#end

#Model użytkownika. Default: User"
#AbstractAuth.implement :user_class do
# User
#end