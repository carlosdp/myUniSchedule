class AddNumberandSectionToCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :number, :integer
    add_column :courses, :section, :string
  end

  def self.down
    remove_column :courses, :number
    remove_column :courses, :section
  end
end
