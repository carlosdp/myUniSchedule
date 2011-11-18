class User < ActiveRecord::Base
  require 'rubygems'
  require 'ri_cal'
  require 'open-uri'
  require 'calparsers.rb'
  include CalParsers
  
  has_one :schedule
  belongs_to :school
  
  def parseCalendar(file)
    
    cal = RiCal.parse(file)
    
    return false if cal.count > 1
    
    self.schedule.destroy if self.schedule
    
    schedule = Schedule.new
    schedule.user = self
    schedule.save!
    
    if self.school.name == "Carnegie Mellon University"
      
      courses = parseCMU(cal.first)
      
      courses.each do |c|
        
        if self.school.courses.exists?({:number => c[:number], :section => c[:section]})
          
          schedule.courses << self.school.courses.find(:first, :conditions => {:number => c[:number], :section => c[:section]})
          
        else
          
          schedule.courses.create(c)
          
        end
        
      end
      
      return true
      
    elsif self.school.name == "University of Pennsylvania"
      
      courses = parseUPenn(cal.first)
      
      courses.each do |c|
        
        if self.school.courses.exists?({:number => c[:number], :start => c[:start]})
          
          schedule.courses << self.school.courses.find(:first, :conditions => {:number => c[:number], :start => c[:start]})
          
        else
          
          schedule.courses.create(c)
          
        end
        
      end
      
      return true
      
    else
      
      return false
      
    end
    
  end
end
