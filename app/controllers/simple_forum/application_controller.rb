module SimpleForum
  class ApplicationController < ::ApplicationController #::ActionController::Base
    protect_from_forgery

    layout SimpleForum.layout

    helper_method :authenticated_user, :user_authenticated?
    helper_method :simple_forum_recent_activity?

    private

    def authenticated_user
      instance_eval &AbstractAuth.invoke(:authenticated_user)
    end

    def user_authenticated?
      instance_eval &AbstractAuth.invoke(:user_authenticated?)
    end

    def authenticate_user
      redirect_to :back, :alert => "You have to be logged in" unless user_authenticated?
    end

    def simple_forum_activity_checker
      @_simple_forum_activity_checker ||= SimpleForum::UserActivity.recent_activity_for_user(authenticated_user)
    end

    def simple_forum_recent_activity?(forum_or_topic)
      return false unless user_authenticated?
      simple_forum_activity_checker.recent_activity?(forum_or_topic)
    end

    def bang_simple_forum_recent_activity(forum_or_topic)
      return unless user_authenticated?
      simple_forum_activity_checker.bang(forum_or_topic)
    end

  end
end



