class AddFormParamsToSchool < ActiveRecord::Migration
  def self.up
    add_column :schools, :has_upload, :boolean, :default => false
    add_column :schools, :has_link_upload, :boolean, :default => false
  end

  def self.down
    remove_column :schools, :has_upload
    remove_column :schools, :has_link_upload
  end
end
