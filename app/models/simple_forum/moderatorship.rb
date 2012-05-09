module SimpleForum
  class Moderatorship < ::ActiveRecord::Base
    belongs_to :forum,
               :class_name => "SimpleForum::Forum"

    belongs_to :user,
               :class_name => instance_eval(&SimpleForum.invoke(:user_class)).name

    validates :forum, :user, :presence => true
    validates :user_id, :uniqueness => {:scope => :forum_id, :allow_nil => true}

    attr_accessible :forum_id, :user_id

  end
end
