AbstractAuth.implement :authenticated_user do
  User.new
end

AbstractAuth.implement :user_authenticated? do
  true
end