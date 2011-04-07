module SimpleForum
  class Moderatorship < ::ActiveRecord::Base

    set_table_name 'simple_forum_moderatorships' #should work table_name_prefix in SimpleForum module but it's not!'

    belongs_to :forum,
               :class_name => "SimpleForum::Forum"

    belongs_to :user,
               :class_name => instance_eval(&AbstractAuth.invoke(:user_class)).name

    validates :forum, :user, :presence => true
    validates :user_id, :uniqueness => {:scope => :forum_id, :allow_nil => true}

    attr_accessible :forum_id, :user_id

  end
end
