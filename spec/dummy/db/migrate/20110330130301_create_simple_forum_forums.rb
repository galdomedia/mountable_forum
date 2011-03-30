class CreateSimpleForumForums < ActiveRecord::Migration
  def self.up
    create_table :simple_forum_forums do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :simple_forum_forums
  end
end
