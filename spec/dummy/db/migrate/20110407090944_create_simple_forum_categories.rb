class CreateSimpleForumCategories < ::ActiveRecord::Migration
  def self.up
    create_table :simple_forum_categories do |t|
      t.string :name
      t.text :body
      t.integer :position

      t.string :slug_cache

      t.timestamps
    end

    add_index :simple_forum_categories, :slug_cache
  end

  def self.down
    drop_table :simple_forum_categories
  end
end
