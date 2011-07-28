class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :fbid
      t.string :name
      t.string :link

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
