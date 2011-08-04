class ChangeNumbersToString < ActiveRecord::Migration
  def self.up
    unless ActiveRecord::Base.configurations[Rails.env]['adapter'] == "sqlite3"
      execute "ALTER TABLE courses ALTER COLUMN number TYPE varchar(255)"
    end
  end

  def self.down
    unless ActiveRecord::Base.configurations[Rails.env]['adapter'] == "sqlite3"
      execute "ALTER TABLE courses ALTER COLUMN number TYPE int"
    end
  end
end
