class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update]

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @author = Author.first_or_create(name: params[:post][:author])
    @post = Post.new(post_params)
    if @post.save
      @post.author = @author
      redirect_to post_path(@post)
    else
      render :new
    end
  end


  def show
    @post = Post.find(params[:id])
    @author = Author.find_by_id(@post.author_id)

    respond_to do |format|
      format.html { render :show }
      # format.json { render json: @post }
      format.json { render json: @post.to_json(
        only: [:title, :description, :id],
        include: [author: { only: [:name] }]
      )}
    end
  end


  def edit
  end

  def update
    @post.update(post_params)
    redirect_to post_path(@post)
  end

  def data
    @post = Post.find(params[:id])
    render json: PostSerializer.serialize(@post)
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
