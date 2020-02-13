class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  PER_PAGE = 10

  def new
    @post = Post.new
  end

  def create
    @post = User.first.posts.build(create_params)

    if @post.save
      redirect_to @post, notice: 'Post created successfully'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @posts = Post.includes(:user).order(created_at: :desc).limit(PER_PAGE)
  end

  def show
    @post = Post.includes(:user).find(params[:id])
  end

  def edit
    @post = Post.includes(:user).find(params[:id])
  end

  def update
    @post = Post.find(params[:id])

    if @post.update_attributes(update_params)
      redirect_to @post, notice: 'Post updated successfully'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:id])

    if @post.destroy
      redirect_to root_url, notice: 'Post deleted successfully'
    else
      redirect_to @post, alert: 'Post could not be deleted'
    end
  end

  private

  def create_params
    params.require(:post).permit(:title, :body)
  end

  def update_params
    params.require(:post).permit(:title, :body)
  end
end
