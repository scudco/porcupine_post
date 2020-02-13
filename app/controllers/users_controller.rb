class UsersController < ApplicationController
  PER_PAGE = 10

  def show
    @posts = Post.includes(:user)
      .where(user_id: params[:id])
      .order(created_at: :desc)
      .limit(PER_PAGE)
  end
end
