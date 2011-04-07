#AbstractAuth.implement :authenticated_user do
#  current_user
#end
#
#AbstractAuth.implement :user_authenticated? do
#  user_signed_in?
#end

#module ActionControllerHelpers
#  extend ActiveSupport::Concern
#
#  included do
#    helper_method :current_user
#  end
#
#  protected
#
#  def current_user
#    @current_user ||= User.find_by_login('test') || User.create(:login => 'test')
#  end
#end
#
#ActiveSupport.on_load(:action_controller) do
#  include ActionControllerHelpers
#end