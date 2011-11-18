class SchedulesController < ApplicationController
  require 'rubygems'
  require 'icalendar'
  require 'open-uri'
  include Icalendar
  
  def is_logged_in_fb?
    
    redirect_to :action => 'index' if !session[:access_token] || !session[:user_id] || !User.exists?(:id => session[:user_id])
    
  end
  
  # GET /schedules
  # GET /schedules.xml
  def index
    
    if logged_in_fb?
      
      #facebook graph
      @graph = current_graph
      @user = @graph.get_object('me')
      
      #current_user's schedule
      @schedule = current_user.schedule
      
      if @schedule
        @colors = ["#FF0000", "#162EAE", "#00AF64", "#CE0071", "#7309AA", "#FF4F00", "#323086", "#CE0071", "#250672", "#000000", "#000000", 
          "#000000", "#000000", "#000000"]
        @textColors = ["#FFFFF", "#FFFFF", "#FFFFF", "#FFFFF", "#FFFFF", "#FFFFF", "#FFFFF", "#FFFFF", "#FFFFF", "#FFFFF", "#FFFFF", 
          "#FFFFF", "#FFFFF", "#FFFFF"]
        @weekds = {"0" => 7, "1" => 8, "2" => 9, "3" => 10, "4" => 11, "5" => 12, "6" => 13}
        @students = Hash.new
        @courses = @schedule.courses
        @courses.each do |c|
          tsch = Course.find_by_id(c.id).schedules
          @students[c.name] = []
          tsch.each do |u|
            @students[c.name] << u.user if u.user.id != session[:user_id]
          end
        
        end
      end
      
    else
      
      @oauth = Koala::Facebook::OAuth.new("#{ENV['SITE'] ? ENV['SITE'] : 'http://localhost:3000'}/o_auth/login")
      
    end
    
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
    
    if params[:schedule][:vcal]
      
      if current_user.parseCalendar(params[:schedule][:vcal].tempfile)
        
        success = true
        
      else
        
        success = false
        flash[:error] = "Invalid file!"
        
      end
      
    elsif params[:schedule][:callink]
      
      theLink = params[:schedule][:callink].include?(".ical") ? params[:schedule][:callink] : params[:schedule][:callink] + ".ics"
      
      if current_user.parseCalendar(open(theLink))
        
        success = true
        
      else
        
        success = false
        flash[:error] = "Invalid file!"
        
      end
      
    end

    respond_to do |format|
      if success 
        format.html { redirect_to(root_path, :notice => 'Schedule was successfully created.') }
        format.xml  { render :xml => @schedule, :status => :created, :location => @schedule }
      else
        format.html { redirect_to root_path }
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
  
end
