class SessionsController < ApplicationController
 def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      if user.activated?
        log_in user
        params[:session][:remember_me].eql? (Settings.params.one) ? remember(user) : forget(user)
        redirect_back_or user
      else
        flash[:warning] = t "user.activation.message"
        redirect_to root_url
      end
    else
      flash.now[:danger] = t "login.fail"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
