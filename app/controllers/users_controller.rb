class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :load_user, only: %i(edit update destroy show)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def new
    @user = User.new
  end

  def index
    @users = User.order("name").page(params[:page])
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t "user.activation.check"
      redirect_to root_path
    else
      flash.now[:danger] = t "user.new.danger"
      render :new
    end
  end

  def update
    if @user.update user_params
      flash[:success] = t "user.edit.updatesuccess"
      redirect_to @user
    else
      flash.now[:danger] = t "user.edit.updatefail"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "user.edit.deletesuccess"
    else
      flash[:warning] = t "user.edit.deletefail"
    end
    redirect_to users_path
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

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "user.login"
      redirect_to login_url
    end
  end

  def correct_user
    redirect_to root_path unless current_user? @user
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
