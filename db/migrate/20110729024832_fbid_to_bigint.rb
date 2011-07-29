class FbidToBigint < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE users ALTER COLUMN fbid TYPE bigint"
  end

  def self.down
    execute "ALTER TABLE users ALTER COLUMN fbid TYPE int"
  end
end
