class SchedulesController < ApplicationController
  require 'rubygems'
  require 'icalendar'
  include Icalendar
  
  def is_logged_in_fb?
    
    redirect_to :action => 'index' if !session[:access_token] || !session[:user_id] || !User.exists?(:id => session[:user_id])
    
  end
  
  # GET /schedules
  # GET /schedules.xml
  def index
    graph = 0
    begin
      @graph = Koala::Facebook::GraphAPI.new(session[:access_token])
      @user = @graph.get_object('me') if session[:access_token]
    rescue
      session[:access_token] = nil
    end
    
    if session[:access_token]
      validUser = false
      
      if !session[:user_id]
      
      if !User.exists?(:fbid => @user["id"])
        if @user["education"]
        @user["education"].each do |e|
          
          if e["type"] == "College" && e["school"]["name"] == "Carnegie Mellon University"
            
            validUser = true
            cuser = User.create({:fbid => @user["id"], :name => @user["name"], :link => @user["link"]})
            session[:user_id] = cuser[:id]
            flash[:success] = "Congratulations! You are now linked to myUniSchedule. Follow the instructions to post your schedule!"
            break
            
          end
        end
          
        else
          
          flash[:error] = "You must allow this site to access your education in facebook!"
          
        end
        
        if !validUser
          
          session[:access_token] = nil
          session[:user_id] = nil
          @user = nil
          flash[:error] = "You must be a Carnegie Mellon University student to register at this time. 
          If you are such a student, please add CMU to your education on your profile and try again."
          
          
        end
        
      else
        
        vuser = User.find_by_fbid(@user["id"])
        session[:user_id] = vuser[:id]
        
      end
      else
        
        if !User.exists?({:id => session[:user_id], :fbid => @user["id"]})
          
          session[:access_token] = nil
          session[:user_id] = nil
          @user = nil
          
        end
        
      end
      
    else
      
      session[:user_id] = nil
      
    end
    
    if session[:user_id]
      
      luser = User.find_by_id(session[:user_id])
      @schedu = luser.schedule
      if @schedu
        @students = Hash.new
        @usermax = 0
        @courses = @schedu.courses
        @courses.each do |c|
          tsch = Course.find_by_id(c.id).schedules
          @students[c.name] = []
          tsch.each do |u|
            @students[c.name] << u.user if u.user.id != session[:user_id]
          end
          @usermax = @students[c.name].count if @students[c.name].count > @usermax
        
        end
      end
      
    end
    
    @oauth = Koala::Facebook::OAuth.new("#{ENV['SITE'] ? ENV['SITE'] : 'http://localhost:3000'}/o_auth/redirect") if !session[:access_token]
    
    @schedules = Schedule.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @schedules }
    end
  end

  # GET /schedules/1
  # GET /schedules/1.xml
  def show
    is_logged_in_fb?
    @schedule = Schedule.find(params[:id])
    
    if @schedule.user.id == session[:user_id]
    
      @courses = @schedule.courses
      
    else
      
      flash[:error] = "This schedule is not yours!"
      
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @schedule }
    end
  end

  # GET /schedules/new
  # GET /schedules/new.xml
  def new
    is_logged_in_fb?
    
    if User.find(session[:user_id]).schedule
      
      redirect_to root_path
      
    else
    
    @schedule = Schedule.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @schedule }
    end
    end
  end

  # GET /schedules/1/edit
  def edit
    is_logged_in_fb?
    #@schedule = Schedule.find(params[:id])
    redirect_to root_path
  end

  # POST /schedules
  # POST /schedules.xml
  def create
    is_logged_in_fb?
    success = true
    
    courselist = parseSchedule(params[:schedule])
    
    if courselist
    @schedule = Schedule.new({:vcal => params[:schedule][:vcal].original_filename})
    @schedule.user = User.find(:first, :conditions => {:id => session[:user_id]})
    @schedule.save!
    
    courselist.each do |c|
      
      if !Course.exists?(:name => c[:name])
        
        @schedule.courses.create(c)
        
      else
        
        @schedule.courses << Course.find(:first, :conditions => {:name => c[:name]})
        
      end
      
    end
    else
      
      success = false 
      flash[:error] = "Invalid iCal file!"
      
    end

    respond_to do |format|
      if success 
        format.html { redirect_to(@schedule, :notice => 'Schedule was successfully created.') }
        format.xml  { render :xml => @schedule, :status => :created, :location => @schedule }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @schedule.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /schedules/1
  # PUT /schedules/1.xml
  def update
    is_logged_in_fb?
    redirect_to root_path
  end

  # DELETE /schedules/1
  # DELETE /schedules/1.xml
  def destroy
    is_logged_in_fb?
    @schedule = Schedule.find(params[:id])
    if @schedule.user.id == session[:user_id]
      @schedule.destroy
    else
      
      flash[:error] = "That's not your schedule silly!"
      
    end

    respond_to do |format|
      format.html { redirect_to(root_path) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def parseSchedule(file)
    begin
    sch = Icalendar.parse(File.new(file[:vcal].tempfile, 'r'))
    rescue
      return false
    end
    classes = Hash.new
    courses = []

    return false if sch.count > 1

    sch.first.events.each do |e|

      weekdys = []

      if !classes[e.summary]
        classes[e.summary] = true
        e.recurrence_rules.each do |r|

          weekdy = r.parse_weekday_list("BYDAY", r.orig_value)
          weekdy.each do |w|

            weekdys << w.to_s.sub(",","")

          end

        end

        courses << {:name => e.summary, :description => e.description, :weekdays => weekdys.compact.to_s, :start => e.dtstart, :end => e.dtend}

      end

    end
    
    return courses
  end
  
end
