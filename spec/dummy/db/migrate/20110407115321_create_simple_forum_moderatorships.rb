class CreateSimpleForumModeratorships < ::ActiveRecord::Migration
  def self.up
    create_table :simple_forum_moderatorships do |t|
      t.references :forum
      t.references :user

      t.timestamps
    end

    add_index :simple_forum_moderatorships, :forum_id
    add_index :simple_forum_moderatorships, :user_id
  end

  def self.down
    drop_table :simple_forum_moderatorships
  end
end
