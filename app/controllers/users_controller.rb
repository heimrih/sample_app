class UsersController < ApplicationController
  before_action :load_user, only: :show

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      log_in @user
      flash[:success] = t "user.new.welcome"
      redirect_to @user
    else
      flash.now[:danger] = t "user.new.danger"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit User::USERS_PARAMS
  end

  def load_user
    @user  = User.find_by id: params[:id]
    return if @user.present?

    flash[:warning] = t "user.new.notfound"
    redirect_to root_path
  end
end
