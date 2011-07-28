class SchedulesController < ApplicationController
  
  def is_logged_in_fb?
    
    redirect_to :action => 'index' if !session[:access_token]
    
  end
  
  # GET /schedules
  # GET /schedules.xml
  def index
    
    if session[:access_token]
      graph = Koala::Facebook::GraphAPI.new(session[:access_token])
      
      @user = graph.get_object('me')
      
      validUser = false
      
      if !User.exists?(:fbid => @user["id"])
        
        @user["education"].each do |e|
          
          if e["type"] == "College" && e["school"]["name"] == "Carnegie Mellon University"
            
            validUser = true
            cuser = User.create({:fbid => @user["id"]})
            session[:user_id] = cuser[:id]
            flash[:success] = "Congratulations! You are now linked to myUniSchedule. Follow the instructions to post your schedule!"
            
          end
          
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
      
    end
    
    @oauth = Koala::Facebook::OAuth.new("http://localhost:3000/o_auth/redirect") if !session[:access_token]
    
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

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @schedule }
    end
  end

  # GET /schedules/new
  # GET /schedules/new.xml
  def new
    is_logged_in_fb?
    @schedule = Schedule.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @schedule }
    end
  end

  # GET /schedules/1/edit
  def edit
    is_logged_in_fb?
    @schedule = Schedule.find(params[:id])
  end

  # POST /schedules
  # POST /schedules.xml
  def create
    is_logged_in_fb?
    @schedule = Schedule.new(params[:schedule])

    respond_to do |format|
      if @schedule.save
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
    @schedule = Schedule.find(params[:id])

    respond_to do |format|
      if @schedule.update_attributes(params[:schedule])
        format.html { redirect_to(@schedule, :notice => 'Schedule was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @schedule.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /schedules/1
  # DELETE /schedules/1.xml
  def destroy
    is_logged_in_fb?
    @schedule = Schedule.find(params[:id])
    @schedule.destroy

    respond_to do |format|
      format.html { redirect_to(schedules_url) }
      format.xml  { head :ok }
    end
  end
end
