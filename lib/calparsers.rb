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
      courseSection = e.summary.delete("-").scan(/\d\d\d\d\d (\w+)/).first.first
      
      if courses.select{|x| x[:number] == courseNumber && x[:section] == courseSection}.count == 0
        
        name = cal.prodid.include?("ScheduleMan") ? e.description[/\A"(.*)"\z/m,1] + " " + courseSection.to_s : e.summary
        dtend = e.dtend ? e.dtend : e.duration_property.add_to_date_time_value(e.dtstart.in_time_zone("Eastern Time (US & Canada)"))
        courses << {:name => name, :description => e.description, :weekdays => days.to_s, :start => e.dtstart.in_time_zone("Eastern Time (US & Canada)"), 
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
        courses << {:name => name, :description => e.description, :weekdays => days.to_s, :start => e.dtstart.in_time_zone("Eastern Time (US & Canada)"), :end => e.dtend.in_time_zone("Eastern Time (US & Canada)"), :number => courseNumber,
          :section => courseSection, :school_id => self.school.id}
        
      else
        
        courses.each do |c|
          
          if c[:number] == courseNumber && c[:start] == e.dtstart.in_time_zone("Eastern Time (US & Canada)")
            
            c[:weekdays] = c[:weekdays] + "," + days.to_s
            
          end
          
        end
        
      end
      
    end
    
    return courses
    
  end
  
  
  
  
end