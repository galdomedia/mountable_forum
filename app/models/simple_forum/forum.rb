module SimpleForum
  class Forum < ::ActiveRecord::Base

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

    validates :name, :presence => true

    attr_accessible :name, :body, :parent_id, :position

    if respond_to?(:has_friendly_id)
      has_friendly_id :name, :use_slug => true, :approximate_ascii => true
    else
      def to_param
        "#{id}-#{name.to_s.parameterize}"
      end
    end

  end
end
