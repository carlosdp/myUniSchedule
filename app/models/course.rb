class Course < ActiveRecord::Base
  has_and_belongs_to_many :schedules
  has_many :users, :through => :schedules
end
