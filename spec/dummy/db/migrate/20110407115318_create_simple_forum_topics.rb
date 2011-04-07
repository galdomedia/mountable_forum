class CreateSimpleForumTopics < ::ActiveRecord::Migration
  def self.up
    create_table :simple_forum_topics do |t|
      t.references :forum
      t.references :user

      t.string :title
      t.boolean :is_closed, :default => false

      t.references :recent_post
      t.datetime :last_updated_at

      t.integer :posts_count, :default => 0
      t.integer :views_count, :default => 0

      t.string :slug_cache

      t.timestamps
    end

    add_index :simple_forum_topics, :forum_id
    add_index :simple_forum_topics, :user_id
    add_index :simple_forum_topics, :last_updated_at
    add_index :simple_forum_topics, :slug_cache
  end

  def self.down
    drop_table :simple_forum_topics
  end
end
