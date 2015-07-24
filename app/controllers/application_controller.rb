class ApplicationController < ActionController::Base
  protect_from_forgery
  #before_filter :check_logined

  private
  def check_logined
    if session[:user] then
      begin
        @user = session[:user]
      rescue ActiveRecord::RecordNotFound
        reset_session
      end
    end

    unless @user
      flash[:referer] = request.fullpath
      redirect_to :controller => 'login', :action => 'index'
    end
  end
end
