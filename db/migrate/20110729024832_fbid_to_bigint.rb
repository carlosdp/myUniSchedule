class FbidToBigint < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE users ALTER COLUMN fbid bigint"
  end

  def self.down
    execute "ALTER TABLE users ALTER COLUMN fbid int"
  end
end
