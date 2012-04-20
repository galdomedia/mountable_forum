module SimpleForum
  class Category < ::ActiveRecord::Base
    has_many :forums,
             :order => "#{SimpleForum::Forum.quoted_table_name}.position ASC",
             :dependent => :nullify,
             :class_name => "SimpleForum::Forum"


    scope :default_order, order("#{quoted_table_name}.position ASC")

    validates :name, :presence => true
    validates :position, :presence => true, :numericality => {:only_integer => true, :allow_nil => true}

    attr_accessible :name, :body, :position

    if respond_to?(:has_friendly_id)
      has_friendly_id :name, :use_slug => true, :approximate_ascii => true
    else
      def to_param
        "#{id}-#{name.to_s.parameterize}"
      end
    end

  end
end
