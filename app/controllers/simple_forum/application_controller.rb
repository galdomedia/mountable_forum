module SimpleForum
  class ApplicationController < ::ApplicationController #::ActionController::Base
    respond_to :html
    #protect_from_forgery

    layout SimpleForum.layout

    helper_method :authenticated_user, :user_authenticated?, :forum_admin?

    private

    def authenticated_user
      instance_eval &SimpleForum.invoke(:authenticated_user)
    end

    def user_authenticated?
      instance_eval &SimpleForum.invoke(:user_authenticated?)
    end

    def authenticate_user
      redirect_to :back, :alert => t('simple_forum.controllers.you_have_to_be_signed_in_to_perform_this_action') unless user_authenticated?
    end

    def forum_admin?
      instance_eval(&SimpleForum.invoke(:forum_admin?))
    end

    def forum_admin_required
      redirect_to simple_forum.root_path unless forum_admin?
    end
  end

end



