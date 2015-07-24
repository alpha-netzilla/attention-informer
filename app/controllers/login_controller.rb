class LoginController < ApplicationController
  skip_before_filter :check_logined

  def index
  end

  def auth
		if params[:name] == "nishin" && params[:password] == "nishin"
      session[:user] = "nishin"
      redirect_to params[:referer]
    else
      flash.now[:referer] = params[:referer]
      @error = 'username / password error'
      render 'index'
    end
  end

  def logout
    reset_session
    redirect_to '/'
  end
end

