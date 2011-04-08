module SimpleForum
  class Post < ::ActiveRecord::Base

    set_table_name 'simple_forum_posts' #should work table_name_prefix in SimpleForum module but it's not!'

    belongs_to :user,
               :class_name => instance_eval(&AbstractAuth.invoke(:user_class)).name

    belongs_to :edited_by,
               :class_name => instance_eval(&AbstractAuth.invoke(:user_class)).name

    belongs_to :deleted_by,
               :class_name => instance_eval(&AbstractAuth.invoke(:user_class)).name

    belongs_to :topic,
               :counter_cache => true,
               :class_name => "SimpleForum::Topic"

    belongs_to :forum,
               :counter_cache => true,
               :class_name => "SimpleForum::Forum"

    before_validation :set_forum_id, :on => :create

    after_create :update_cached_fields
    after_destroy :update_cached_fields

    scope :recent, order("#{quoted_table_name}.created_at DESC")

    attr_accessible :body
    validates :topic, :forum, :user, :presence => true
    validates :body, :presence => true

    validate :topic_must_not_be_closed, :on => :create

    def topic_must_not_be_closed
      errors.add(:base, I18n.t('simple_forum.errors.topic_is_close', :default => "Topic is closed.")) if topic && topic.is_closed?
    end

    def on_page
      before_count = topic.posts.where(["#{SimpleForum::Post.quoted_table_name}.created_at<?", created_at]).size
      [((before_count + 1).to_f / SimpleForum::Post.per_page).ceil.to_i, 1].max
    end

    def self.per_page
      15
    end

    def output
      body.bbcode_to_html
    end

    def output_without_tags
      HTML::FullSanitizer.new.sanitize(output.gsub(/\<fieldset\>\<legend\>.*\<\/legend\>\<blockquote\>(.|\n)*\<\/blockquote\>/, ''))
    end

    def editable_by?(user, is_moderator=false)
      return false if is_deleted?
      is_moderator = forum.is_moderator?(user) if is_moderator.nil?
      return true if is_moderator
      created_at > SimpleForum.minutes_for_edit_post.minutes.ago && user == self.user
    end

    def deletable_by?(user, is_moderator=false)
      return false if is_deleted?
      is_moderator = forum.is_moderator?(user) if is_moderator.nil?
      return true if is_moderator
      created_at > SimpleForum.minutes_for_delete_post.minutes.ago && user == self.user
    end

    def is_deleted
      !!deleted_at
    end

    alias_method :is_deleted?, :is_deleted

    def is_edited
      !!edited_at
    end

    alias_method :is_edited?, :is_edited

    def mark_as_deleted_by(user)
      return false unless deletable_by?(user, nil)
      self.deleted_at = Time.now
      self.deleted_by = user
      self.save
    end

    protected

    def update_cached_fields
      topic.update_cached_post_fields(self) if topic
      if user && user.respond_to?(:forum_posts_count)
        user.class.update_all({:forum_posts_count => SimpleForum::Post.where(:user_id => user.id).count}, {:id => user.id})
      end
    end

    def set_forum_id
      self.forum = topic.forum if topic
    end
  end
end
