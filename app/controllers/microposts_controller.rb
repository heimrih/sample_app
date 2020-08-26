class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach params[:micropost][:image]
    if @micropost.save
      flash[:success] = t "micropost.create"
      redirect_to root_path
    else
      @feed_items = current_user.feed.page params[:page]
      flash.now[:danger] = t "micropost.failcreate"
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "micropost.delete"
    else
      flash[:warning] = t "micropost.faildelete"
    end
    redirect_back fallback_location: root_path
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :image
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:warning] = t "micropost.notfound"
    redirect_to root_path
  end
end
