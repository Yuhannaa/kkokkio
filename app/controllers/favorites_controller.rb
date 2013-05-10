class FavoritesController < ApplicationController
  before_action :signed_in_user

  def create
    @post = Post.find(params[:favorite][:post_id])
    current_user.favorite!(@post)
    respond_to do |format|
      format.html { redirect_to(request.env["HTTP_REFERER"]) }
      format.js
    end
  end

  def destroy
    @post = Favorite.find(params[:id]).post
    current_user.undo_favorite!(@post)
    respond_to do |format|
      format.html { redirect_to(request.env["HTTP_REFERER"]) }
      format.js
    end
  end
end