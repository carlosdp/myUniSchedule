class FbidToBigint < ActiveRecord::Migration
  def self.up
    unless ActiveRecord::Base.configurations[Rails.env]['adapter'] == "sqlite3"
    execute "ALTER TABLE users ALTER COLUMN fbid TYPE bigint"
    end
  end

  def self.down
    unless ActiveRecord::Base.configurations[Rails.env]['adapter'] == "sqlite3"
    execute "ALTER TABLE users ALTER COLUMN fbid TYPE int"
    end
  end
end
