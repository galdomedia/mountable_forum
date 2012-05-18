module SimpleForum
  class UserActivity < ::ActiveRecord::Base

    class Checker
      attr_reader :user, :hash

      def initialize(user, hash)
        @user = user
        @hash = hash
      end

      def recent_activity?(object)
        type = object.class.base_class.name.to_sym
        hash[type] ||= {}
        read_at = hash[type][object.id]
        return unless read_at

        if object.is_a?(SimpleForum::Forum)
          recent_post = object.recent_post
          recent_post && recent_post.created_at > read_at
        elsif object.is_a?(SimpleForum::Topic)
          object.last_updated_at && object.last_updated_at > read_at
        elsif object.respond_to?(:updated_at)
          object.updated_at > self[object]
        end
      end

      def bang(object)
        return unless user
        UserActivity.bang(object, user)
      end

    end

    belongs_to :user,
               :class_name => instance_eval(&SimpleForum.invoke(:user_class)).name

    belongs_to :memoryable, :polymorphic => true

    scope :only_read, where("#{quoted_table_name}.read_at IS NOT NULL")

    def self.recent_activity_for_user(user)
      if user && user.persisted?
        u = user
        hash = self.where(:user_id => user.try(:id)).to_hash
      else
        u = nil
        hash = {}
      end
      Checker.new(u, hash)
    end

    def self.to_hash(collection=nil)
      collection ||= only_read.all
      {}.tap do |hash|
        collection.each do |a|
          hash[a.memoryable_type.to_sym] ||= {}
          hash[a.memoryable_type.to_sym][a.memoryable_id] = a.read_at
        end
      end
    end

    def self.bang(object, user)
      if am = load(object, user)
        update_all({:read_at => Time.now}, {:id => am.id})
      else
        am = create_for(object, user)
      end
      am
    end

    def self.load(object, user, conditions=nil)
      scope = self.where({:memoryable_type => object.class.name, :memoryable_id => object.id, :user_id => user.id})
      scope = scope.where(conditions) if conditions
      scope.first
    end

    def self.create_for(object, user, time=Time.now)
      SimpleForum::UserActivity.create do |m|
        m.memoryable = object
        m.user = user
        m.read_at = time
      end
    end

  end
end