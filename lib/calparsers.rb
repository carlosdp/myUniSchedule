module CalParsers
  
  
  def parseCMU(cal)
    
    courses = []
    
    cal.events.each do |e|
      
      days = []
      
      e.occurrences(:starting => e.dtstart, :count => 6).each do |o|
        
        if !days.include?(o.dtstart.wday)
          
          days << o.dtstart.wday
          
        else
          
          break #break occurrence loop if we have reached duplicate
          
        end
        
      end
      
      courseNumber = e.summary.delete("-").scan(/(\d\d\d\d\d)/).first.first
      courseSection = ""
      
      if e.summary.include?("Lec")
        courseSection = e.summary[/\A"(.*)"\z/m,1].last.upcase
        
        if !(courseSection =~ /^[-+]?[0-9]+$/)
          courseSection = "1"
        end
        
      else
        courseSection = e.summary.delete("-").scan(/\d\d\d\d\d (\w+)/).first.first
      end
      
      if courses.select{|x| x[:number] == courseNumber && x[:section] == courseSection}.count == 0
        
        dtstart = cal.prodid.include?("ScheduleMan") ? e.dtstart - 5.hours : e.dtstart
        name = cal.prodid.include?("ScheduleMan") ? e.description[/\A"(.*)"\z/m,1] + " " + courseSection.to_s : e.summary
        dtend = e.dtend ? e.dtend : e.duration_property.add_to_date_time_value(dtstart)
        courses << {:name => name, :description => e.description, :weekdays => days.to_s, :start => dtstart, 
          :end => dtend, :number => courseNumber, :section => courseSection, :school_id => self.school.id}
        
      end
      
    end
    
    return courses
    
  end
  
  def parseUPenn(cal)
    
    courses = []
    
    cal.events.each do |e|
      
      days = []
      
      e.occurrences(:starting => e.dtstart, :count => 6).each do |o|
        
        if !days.include?(o.dtstart.wday)
          
          days << o.dtstart.wday
          
        else
          
          break #break occurrence loop if we have reached duplicate
          
        end
        
      end
      
      courseNumber = e.summary
      courseSection = e.summary
      
      if courses.select{|x| x[:number] == courseNumber && x[:start] == e.dtstart}.count == 0
        
        name = e.summary
        courses << {:name => name, :description => e.description, :weekdays => days.to_s, :start => e.dtstart - 5.hours, :end => e.dtend.in_time_zone("Eastern Time (US & Canada)"), :number => courseNumber,
          :section => courseSection, :school_id => self.school.id}
        
      else
        
        courses.each do |c|
          
          if c[:number] == courseNumber && c[:start] == e.dtstart - 5.hours
            
            c[:weekdays] = c[:weekdays] + "," + days.to_s
            
          end
          
        end
        
      end
      
    end
    
    return courses
    
  end
  
  
  
  
end