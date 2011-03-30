class CreateSimpleForumForums < ::ActiveRecord::Migration
  def self.up
    create_table :simple_forum_forums do |t|
      t.string :name
      t.text :body
      t.integer :position, :default => 0
      t.boolean :is_topicable, :default => true

      t.references :recent_topic
      t.references :recent_post

#      t.references :parent
#      t.integer :lft
#      t.integer :rgt

      t.integer :topics_count, :default => 0
      t.integer :posts_count, :default => 0

      t.string :slug_cache

      t.timestamps
    end

    add_index :simple_forum_forums, :parent_id
    add_index :simple_forum_forums, :lft
    add_index :simple_forum_forums, :slug_cache
  end

  def self.down
    drop_table :simple_forum_forums
  end
end
