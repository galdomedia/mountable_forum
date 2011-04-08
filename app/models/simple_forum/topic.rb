module SimpleForum
  class Topic < ::ActiveRecord::Base

    set_table_name 'simple_forum_topics' #should work table_name_prefix in SimpleForum module but it's not!'

    belongs_to :user, :class_name => instance_eval(&AbstractAuth.invoke(:user_class)).name

    belongs_to :forum,
               :class_name => "SimpleForum::Forum", :counter_cache => true

    has_many :posts,
             :order => "#{SimpleForum::Post.quoted_table_name}.created_at ASC",
             :class_name => "SimpleForum::Post",
             :dependent => :delete_all

    belongs_to :recent_post,
               :class_name => "SimpleForum::Post"

    has_one :first_post,
            :order => "#{SimpleForum::Post.quoted_table_name}.created_at ASC",
            :class_name => "SimpleForum::Post"


    validates :title, :forum, :presence => true
    validates :user, :presence => true, :on => :create
    validates :body, :presence => true, :on => :create
    validate :forum_must_be_topicable, :on => :create

    def forum_must_be_topicable
      errors.add(:base, t('simple_forum.validations.forum_must_be_topicable')) if forum && !forum.is_topicable?
    end

    before_validation :set_default_attributes, :on => :create
    after_create :create_initial_post

    attr_accessor :body
    attr_accessible :title, :body

    def update_cached_post_fields(post)
      if remaining_post = post.frozen? ? recent_post : post
        self.class.update_all({:last_updated_at => remaining_post.created_at,
                               :recent_post_id => remaining_post.id,
                               # :posts_count => posts.size
                              }, {:id => id})
        forum.class.update_all({:recent_post_id => remaining_post.id}, {:id => forum.id})
      else
        destroy
      end
    end

    def paged?
      posts.size > SimpleForum::Post.per_page
    end

    def last_page
      @last_page ||= [(posts.size.to_f / SimpleForum::Post.per_page).ceil.to_i, 1].max
    end

    #return array with page numbers
    # topic.page_numbers => [1, 2, 3, 4] #when pages count is 4
    # topic.page_numbers => [1, 2, 3, 4, 5] #when pages count is 5
    # topic.page_numbers => [1, nil, 3, 4, 5, 6] #when pages count is 6
    # topic.page_numbers => [1, nil, 4, 5, 6, 7] #when pages count is 7
    def page_numbers(max=5)
      if last_page > max
        [1] + [nil] + ((last_page-max+2)..last_page).to_a
      else
        (1..last_page).to_a
      end
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

    def recent_activity?(user)
      SimpleForum::UserActivity.new(user).recent_activity?(self)
    end

    def bang_recent_activity(user)
      SimpleForum::UserActivity.new(user).bang(self)
    end

    def increment_views_count
      self.class.increment_counter(:views_count, self)
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
