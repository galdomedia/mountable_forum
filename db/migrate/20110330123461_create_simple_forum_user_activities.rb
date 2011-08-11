class CreateSimpleForumUserActivities < ::ActiveRecord::Migration
  def self.up
    create_table :simple_forum_user_activities do |t|
      t.references :memoryable, :polymorphic => {:limit => 50}
      t.references :user
      t.datetime :read_at

      t.timestamps
    end

    add_index :simple_forum_user_activities, :user_id
  end

  def self.down
    drop_table :simple_forum_user_activities
  end
end
