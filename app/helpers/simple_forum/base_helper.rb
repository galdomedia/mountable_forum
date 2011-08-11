module SimpleForum::BaseHelper

  def simple_forum_activity_checker
    @_simple_forum_activity_checker ||= Simple::Forum::UserActivity.recent_activity_for_user(authenticated_user)
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