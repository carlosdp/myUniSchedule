# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

require 'csv'

@array_of_colleges = CSV.read('Accreditation_2011_08.csv')

@array_of_colleges.slice!(0)

@array_of_colleges.each do |row|
  
  if(!School.exists?(:name => row[1]))
    
    School.create({:name => row[1], :street => row[2], :city => row[3], :state => row[4], :zip => row[5], :website => row[9]})
    
  end
  
end