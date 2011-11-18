class OAuthController < ApplicationController
  
  def login
    
    session[:access_token] = Koala::Facebook::OAuth.new("#{ENV['SITE'] ? ENV['SITE'] : 'http://localhost:3000'}/o_auth/login").get_access_token(params[:code]) if params[:code]
    
    begin
      @graph = Koala::Facebook::GraphAPI.new(session[:access_token])
      @user = @graph.get_object('me')
    rescue
      session[:access_token] = nil
    ensure
      @graph = false if !session[:access_token]
    end
    
    if logged_in_fb? #if user is logged into site and into Facebook
      validUser = false
      
      if User.exists?(:fbid => @user["id"]) #if the FB user is already registered, log him in
      
        vuser = User.find_by_fbid(@user["id"])
        session[:user_id] = vuser[:id]
      
      else #if he is not registered, set him up
        if @user["education"] #do we have education permissions?
          @user["education"].each do |e| #REPLACE EDUCATION SORTING CODE HERE!
        
            if e["type"] == "College" && School.exists?(:name => e["school"]["name"])
          
              validUser = true
              cuser = School.find_by_name(e["school"]["name"]).users.create({:fbid => @user["id"], :name => @user["name"], :link => @user["link"]})
              session[:user_id] = cuser[:id]
              flash[:success] = "Congratulations! You are now linked to myUniSchedule. Follow the instructions to post your schedule!"
              break
          
            end
          end
        
        else #no we don't, throw them out
        
          flash[:error] = "You must allow this site to access your education in facebook!"
        
        end
      
        if !validUser #if we did not establish the user was valid, throw them out
          
          session[:access_token] = nil
          session[:user_id] = nil
          @user = nil
          redirect_to 'o_auth/choose', :code => params[:code]
          
        end
      
      end
      
    else
      
      session[:access_token] = nil
      session[:user_id] = nil
      @user = nil
      
    end
    
    redirect_to root_path
    
  end
  
  def choose
    
    @schools = School.get_similar(params[:school])
    
    respond_to do |format|
      
      format.html
      
    end
    
  end
  
  def logout
    
    if session[:user_id]
      
      session[:access_token] = nil
      session[:user_id] = nil
      flash[:success] = "Successfully logged out of session!"
      
      redirect_to root_path
      
    else
      
      redirect_to root_path
      
    end
    
  end

end
