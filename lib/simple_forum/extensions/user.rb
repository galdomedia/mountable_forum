module SimpleForum::Extensions
  module User
    extend ActiveSupport::Concern

    included do
      has_many :simple_forum_posts, :class_name => 'SimpleForum::Post', :dependent => :destroy
    end

    module ClassMethods

    end

    #def forum_posts_count
    #  self.simple_forum_posts.count
    #end

  end
end