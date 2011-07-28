class AddCoursesSchedulesTable < ActiveRecord::Migration
  def self.up
    create_table :courses_schedules, :id => false do |t|
      
      t.integer :course_id
      t.integer :schedule_id
      
    end
  end

  def self.down
    drop_table "courses_schedules"
  end
end
