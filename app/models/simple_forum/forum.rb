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

#    has_many :activity_memories, :as => :memoryable, :class_name => 'Forum::ActivityMemory' do
#      def for_user(user)
#        where(:user_id => user).first
#      end
#    end

    scope :default_order, order("#{SimpleForum::Forum.quoted_table_name}.position ASC")

    validates :name, :presence => true

    attr_accessible :name, :body, :parent_id, :position

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

  end
end
