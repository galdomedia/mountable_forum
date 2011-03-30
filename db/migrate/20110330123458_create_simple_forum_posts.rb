class CreateSimpleForumPosts < ::ActiveRecord::Migration
  def self.up
    create_table :simple_forum_posts do |t|
      t.references :topic
      t.references :forum
      t.references :user

      t.text :body

      t.string :slug_cache

      t.timestamps
    end

    add_index :simple_forum_posts, :topic_id
    add_index :simple_forum_posts, :forum_id
    add_index :simple_forum_posts, :user_id
    add_index :simple_forum_posts, :slug_cache
  end

  def self.down
    drop_table :simple_forum_posts
  end
end
