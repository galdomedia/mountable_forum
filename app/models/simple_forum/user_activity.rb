require 'pstore'

class SimpleForum::UserActivity

  PATH = Rails.root.join("file_store")
  FILE = "simple_forum_activity"
  FileUtils.mkdir_p(PATH)

  attr_reader :user

  def recent_activity?(object)
    self[object] > Time.now
    return false unless user.try(:id)
    if object.is_a?(SimpleForum::Forum)
      if recent_post = object.recent_post
        recent_post.created_at > self[object]
      else
        false
      end
    else #SimpleForum::Topic
      if object.last_updated_at
        object.last_updated_at > self[object]
      else
        false
      end
    end
  end

  def initialize(user)
    @user = user
  end

  def self.store
    @@store ||= PStore.new(File.join(PATH, FILE))
  end

  def store
    self.class.store
  end

  def [](object, default=Time.now)
    ret = nil
    store.transaction(true) do
      user_hash = store[user.id] || {}
      object_hash = user_hash[key_for_object(object)] || {}
      ret = object_hash[object.id]
    end if user.try(:id)
    ret || default
  end

  def bang(object)
    store.transaction do
      user_hash = store[user.id] || {}
      object_hash = (user_hash[key_for_object(object)] ||= {})
      object_hash[object.id] = Time.now
      store[user.id] = user_hash
    end if user.try(:id)
    nil
  end

  def destroy
    store.transaction do
      store.delete(user.id)
    end
  end

  private

  def key_for_object(object)
    case object
      when SimpleForum::Forum then
        :f
      when SimpleForum::Topic then
        :t
      else
        object.model_name.cache_key
    end
  end

end