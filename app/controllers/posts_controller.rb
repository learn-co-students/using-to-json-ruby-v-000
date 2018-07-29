class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update]

  def index
    @posts = Post.all
  end

  def show
    # NOTE : Deciding what to display here rather than using "post_data" route
    @post = Post.find(params[:id])
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @post.to_json(only: [:title, :description, :id], include: [author: { only: [:name]}]) }
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
    
    # NOTE : Swap the serializer for "to_json" 
      # render json: post.to_json
      
    # NOTE : Include associations using the "include" option
      # render json: post.to_json(include: :author)
      
    # NOTE : Exclude unnecessary information using the "only" option -- works on both the main object AND associated (though need to pass the associated further as a param)
    render json: post.to_json(only: [:title, :description, :id], include: [ author: { only: [:name]}])
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
