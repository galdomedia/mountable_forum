class CreateSimpleForumPosts < ::ActiveRecord::Migration
  def self.up
    create_table :simple_forum_posts do |t|
      t.references :topic
      t.references :forum
      t.references :user

      t.text :body

      t.references :deleted_by
      t.datetime :deleted_at
      t.references :edited_by
      t.datetime :edited_at

      t.string :slug_cache

      t.timestamps
    end

    add_index :simple_forum_posts, :topic_id
    add_index :simple_forum_posts, :forum_id
    add_index :simple_forum_posts, :user_id
    add_index :simple_forum_posts, :deleted_by_id
    add_index :simple_forum_posts, :edited_by_id
    add_index :simple_forum_posts, :slug_cache
  end

  def self.down
    drop_table :simple_forum_posts
  end
end
