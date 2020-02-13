class UsersController < ApplicationController
  PER_PAGE = 10

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.includes(:user)
      .order(created_at: :desc)
      .limit(PER_PAGE)
  end
end
