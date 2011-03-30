class CreateForums < ActiveRecord::Migration
  def self.up
    create_table :forum_forums do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :forum_forums
  end
end


