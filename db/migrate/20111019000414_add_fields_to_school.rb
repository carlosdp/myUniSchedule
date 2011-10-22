class AddFieldsToSchool < ActiveRecord::Migration
  def self.up
    add_column :schools, :street, :string
    add_column :schools, :city, :string
    add_column :schools, :state, :string
    add_column :schools, :zip, :string
    add_column :schools, :website, :string
  end

  def self.down
    remove_column :schools, :street
    remove_column :schools, :city
    remove_column :schools, :state
    remove_column :schools, :zip
    remove_column :schools, :website
  end
end
