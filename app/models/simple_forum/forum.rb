module SimpleForum
  class Forum < ::ActiveRecord::Base

    set_table_name 'simple_forum_forums' #should work table_name_prefix in SimpleForum module but it's not!'

    #acts_as_nested_set

    has_many :topics,
             :order => "#{SimpleForum::Topic.quoted_table_name}.last_updated_at DESC",
             :dependent => :destroy,
             :class_name => "SimpleForum::Topic"

    belongs_to :recent_topic,
               :class_name => 'SimpleForum::Topic'

    has_many :posts,
             :order => "#{SimpleForum::Post.quoted_table_name}.created_at DESC",
             :class_name => 'SimpleForum::Post'

    belongs_to :recent_post,
               :class_name => 'SimpleForum::Post'

    belongs_to :category,
               :class_name => 'SimpleForum::Category'

    has_many :moderatorships,
             :class_name => 'SimpleForum::Moderatorship'

    has_many :moderators,
             :through => :moderatorships,
             :source => :user

    scope :default_order, order("#{quoted_table_name}.position ASC")

    validates :name, :presence => true
    validates :position, :presence => true, :numericality => {:only_integer => true, :allow_nil => true}

    attr_accessible :name, :body, :parent_id, :position, :moderator_ids, :category_id

    if respond_to?(:has_friendly_id)
      has_friendly_id :name, :use_slug => true, :approximate_ascii => true
    else
      def to_param
        "#{id}-#{name.to_s.parameterize}"
      end
    end

    def recent_activity?(user)
      SimpleForum::UserActivity.new(user).recent_activity?(self)
    end

    def bang_recent_activity(user)
      SimpleForum::UserActivity.new(user).bang(self)
    end

    def moderated_by?(user)
      return false unless user
      @moderated_by_cache ||= {}
      if @moderated_by_cache.has_key?(user.id)
        @moderated_by_cache[user.id]
      else
        @moderated_by_cache[user.id] = moderators.include?(user)
      end
    end

    alias_method :is_moderator?, :moderated_by?

  end
end
