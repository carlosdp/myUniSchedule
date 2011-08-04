class ChangeNumbersToString < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE courses ALTER COLUMN number TYPE varchar(255)"
  end

  def self.down
    execute "ALTER TABLE courses ALTER COLUMN number TYPE int"
  end
end
