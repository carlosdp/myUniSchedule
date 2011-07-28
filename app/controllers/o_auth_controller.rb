class OAuthController < ApplicationController
  def redirect
    session[:access_token] = Koala::Facebook::OAuth.new("http://localhost:3000/o_auth/redirect").get_access_token(params[:code]) if params[:code]

    redirect_to :controller => 'schedules', :action => 'index'
  end

end
