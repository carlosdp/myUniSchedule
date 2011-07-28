class OAuthController < ApplicationController
  def redirect
    session[:access_token] = Koala::Facebook::OAuth.new("http://localhost:3000/o_auth/redirect").get_access_token(params[:code]) if params[:code]
    
    redirect_to :controller => 'schedules', :action => 'index'
  end
  
  def logout
    
    if session[:user_id]
      
      session[:access_token] = nil
      session[:user_id] = nil
      flash[:success] = "Successfully logged out of session!"
      
      redirect_to :controller => 'schedules', :action => 'index'
      
    else
      
      redirect_to :controller => 'schedules', :action => 'index'
      
    end
    
  end

end
