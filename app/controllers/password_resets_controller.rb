class PasswordResetsController < ApplicationController
  before_action :get_user, only: %i(create edit update)
  before_action :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "forgot.success"
      redirect_to root_path
    else
      flash.now[:danger] = t "forgot.fail"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].blank?
      @user.errors.add :password, t("forgot.reset.error")
      render :edit
    elsif @user.update user_params
      log_in @user
      @user.update_attribute :reset_digest, nil
      flash[:success] = t "forgot.reset.success"
      redirect_to @user
    else
      flash.now[:warning] = t "forgot.reset.fail"
      render :edit
    end
  end

  private

  def user_params
    params.require :user.permit :password, :password_confirmation
  end

  def get_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:warning] = t "user.new.notfound"
    redirect_to root_path
  end

  def valid_user
    return if @user && @user.authenticated?(:reset, params[:id])
      flash[:warning] = t "user.new.notfound"
      redirect_to root_path
  end

  def check_expiration
    return unless @user.password_reset_expired?
      flash[:danger] = t "forgot.reset.sessionexpire"
      redirect_to new_password_reset_url
  end
end
