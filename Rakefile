# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake/dsl_definition'
require 'rake'

Myunischedule::Application.load_tasks

namespace :users do
  
  desc "Get number of users"
  task :count => :environment do
    
    puts "User Count: #{User.all.count}"
    
  end
  
  desc "Conform to new school system"
  task :conformCmu => :environment do
    
    puts "Adding CMU to every user."
    
    school = School.create({:name => "Carnegie Mellon University"})
    User.update_all("school_id = '#{school.id}'")
    
    puts "Done"
    
  end
  
  desc "Make fake user"
  task :fake => :environment do
    
    puts "Making fake user"
    
    school = School.find(1)
    user = User.create({:name => "John Doe", :link => "http://google.com"})
    user.school = school
    
    user.create_schedule({:vcal => "cool"})
    
    sched = Schedule.find(user.schedule.id)
    
    sched.courses.create({:description => "INTRO DATA :: 15121 A"})
    
  end
  
end

namespace :schools do
  
  desc "Add school"
  task :create, :name, :needs => :environment do |t, args|
    
    puts "Creating school #{args[:name]}"
    
    school = School.create({:name => args[:name]})
    
    puts "School ID: #{school.id}"
    
  end
  
end

namespace :courses do
  
  desc "Get number of courses"
  task :count => :environment do
    
    puts "Courses Count: #{Course.all.count}"
    
  end
  
  task :parse => :environment do
    
    puts "Let's parse these courses"
    
    courses = Course.all
    
    puts "Courses: #{courses.count}"
    puts "Here we go"
    
    i=0
    
    courses.each do |c|
      
      str = c.name
      if str.scan(/(\d\d\d\d\d)/).count > 0
        c.update_attributes({:number => str.scan(/(\d\d\d\d\d)/).first.first.to_i, :section => str.scan(/\d\d\d\d\d (\w+)/).first.first})
      end
      
      i+=1
    end
    
    puts "Done! #{i} rows affected"
    puts "Merging doubles now"
    
    courses = Course.all
    
    seenN = Hash.new
    
    courses.each do |c|
      
      if c.number && seenN[c.number.to_s+c.section] && c.name == c.name.upcase
        
        puts "removing dups: #{c.name}"
        scheds = c.schedules
        scheds.each do |s|
          
          s.courses << Course.find(seenN[c.number.to_s+c.section])
          s.courses.delete(c)
          
        end
        
      elsif c.number
        
        seenN[c.number.to_s+c.section] = c.id unless seenN[c.number.to_s+c.section]
        
      end
      
    end
    
  end
  
  task :fixPenn => :environment do 
    
    puts "Let's do this"
    
    courses = School.find_by_name("University of Pennsylvania").courses
    
    courses.each do |c|
      
      if c.number.length < 5
        puts "Fixing #{c.name}"
        temp = c.number
        while(temp.length < 5)
          
          temp = "0" + temp
          
        end
        
        c.update_attributes({:number => temp})
        
      end
      
    end
    
    puts "Done!"
    
  end
  
  task :printPennCourses => :environment do
    
    courses = School.find_by_name("University of Pennsylvania")
    
    courses.each do |c|
      
      puts c.number
      
    end
    
  end
  
  desc "Add CMU School ID"
  task :addid => :environment do
    
    schoolid = School.find_by_name("Carnegie Mellon University").id
    
    puts "Found CMU: #{schoolid}"
    
    courses = Course.all
    
    courses.each do |c|
      
      c.update_attributes({:school_id => schoolid})
      
    end
    
    puts "Done!"
    
  end
  
end