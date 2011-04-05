module SimpleForum
  class Post < ::ActiveRecord::Base

    set_table_name 'simple_forum_post' #should work table_name_prefix in SimpleForum module but it's not!'

    belongs_to :user

    belongs_to :topic,
               :class_name => "SimpleForum::Topic"

    belongs_to :forum,
               :class_name => "SimpleForum::Forum"

    before_validation :set_forum_id, :on => :create

    after_create :update_cached_fields
    after_destroy :update_cached_fields

#    after_create lambda { |p| p.forum.set_recent_post(p) }
#    after_destroy lambda { |p| p.forum.set_recent_post(p.topic.recent_post) unless p.topic.frozen? }
#
#    after_create lambda { |p| p.forum.set_recent_topic_if_needed(p.reload.topic) }
#    after_destroy lambda { |p| p.forum.set_recent_topic_if_needed(p.forum.topics.first) }

    scope :recent, order("#{SimpleForum::Post.quoted_table_name}.created_at DESC")

    attr_accessible :body
    validates :topic, :forum, :user, :presence => true

    validate :topic_must_not_be_closed, :on => :create

    def topic_must_not_be_closed
      errors.add(:base, I18n.t('simple_forum.errors.topic_is_close', :default => "Topic is closed.")) if topic && topic.is_closed?
    end

    def on_page
      before_count = topic.posts.size(:conditions => ["#{SimpleForum::Post.quoted_table_name}.created_at<?", created_at])
      [((before_count + 1).to_f / SimpleForum::Post.per_page).ceil.to_i, 1].max
    end

    def self.per_page
      15
    end

    def output
      body.respond_to?(:bbcode_to_html) ? body.bbcode_to_html : body
    end

    def output_without_tags
      HTML::FullSanitizer.new.sanitize(output.gsub(/\<fieldset\>\<legend\>.*\<\/legend\>\<blockquote\>(.|\n)*\<\/blockquote\>/, '')).html_safe
    end

    protected

    def update_cached_fields
      topic.update_cached_post_fields(self) if topic
    end

    def set_forum_id
      self.forum = topic.forum if topic
    end
  end
end
