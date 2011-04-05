module SimpleForum
  class Topic < ::ActiveRecord::Base

    set_table_name 'simple_forum_topics' #should work table_name_prefix in SimpleForum module but it's not!'

    belongs_to :user

    belongs_to :forum,
               :class_name => "SimpleForum::Forum"

    has_many :posts,
             :order => "#{SimpleForum::Post.quoted_table_name}.created_at ASC",
             :class_name => "SimpleForum::Post",
             :dependent => :delete_all

    belongs_to :recent_post,
               :class_name => "SimpleForum::Post"

    has_one :first_post,
            :order => "#{SimpleForum::Post.quoted_table_name}.created_at ASC",
            :class_name => "SimpleForum::Post"

    after_create lambda { |t| t.forum.update_counters }
    after_destroy lambda { |t| t.forum.update_counters }

    after_create lambda { |t| t.forum.set_recent_topic_if_needed(t) }
    after_destroy lambda { |t| t.forum.set_recent_topic_if_needed(t.forum.topics.first) }

    validates :title, :forum, :presence => true
    validates :user, :presence => true
    validates :body, :presence => true, :on => :create

    before_validation :set_default_attributes, :on => :create
    after_create :create_initial_post

    attr_accessor :body
    attr_accessible :title, :body

    def update_cached_post_fields(post)
      if remaining_post = post.frozen? ? recent_post : post
        self.class.update_all({:last_updated_at => remaining_post.created_at,
                               :last_user_id => remaining_post.user_id,
                               :last_post_id => remaining_post.id,
                               :posts_count => posts.size
                              }, {:id => id})
      else
        destroy
      end
    end

    def paged?
      posts.size > SimpleForum::Post.per_page
    end

    def last_page
      [(posts.size.to_f / SimpleForum::Post.per_page).ceil.to_i, 1].max
    end

    if respond_to?(:has_friendly_id)
      has_friendly_id :title, :use_slug => true, :approximate_ascii => true
    else
      def to_param
        "#{id}-#{title.to_s.parameterize}"
      end
    end

    def author?(u)
      user == u
    end

    def is_open
      !is_closed?
    end

    alias_method :is_open?, :is_open

    def open!
      update_attribute(:is_closed, false)
    end

    def close!
      update_attribute(:is_closed, true)
    end

    private

    def set_default_attributes
      self.last_updated_at ||= Time.now
    end

    def create_initial_post
      p = self.posts.new(:body => @body) do |post|
        post.user = user
      end
      p.save!
      @body = nil
    end
  end
end
