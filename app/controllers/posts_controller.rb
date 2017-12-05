class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update]

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
    respond_to do |format|
      format.html {render :show} #lets you choose which format - can type .html or .json at end of route
      format.json {render json: @post.to_json(only: [:title, :description, :id], include: [author: { only: [:name]}]) }
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.create(post_params)
    @post.save
    redirect_to post_path(@post)
  end

  def edit
  end

  def update
    @post.update(post_params)
    redirect_to post_path(@post)
  end

  def post_data
    post = Post.find(params[:id])
    render json: post.to_json(only: [:title, :description, :id], include: [author: {only: [:name]}])
    # can use only on main and included objects, author must be passed in an array for include
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:post).permit(:title, :description)
  end
end
