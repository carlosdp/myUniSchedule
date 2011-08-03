class ApplicationController < ActionController::Base
  before_filter :ensure_domain
  
  protect_from_forgery
  
  APP_DOMAIN = ENV['APP_DOMAIN'] ? ENV['APP_DOMAIN'] : "localhost:3000"

    def ensure_domain
      if request.env['HTTP_HOST'] != APP_DOMAIN
        # HTTP 301 is a "permanent" redirect
        redirect_to "http://#{APP_DOMAIN}", :status => 301
      end
    end
    
    def current_user
      
      if session[:user_id] && User.exists?(:id => session[:user_id])
        User.find(session[:user_id])
      else
        false
      end
      
    end
end
