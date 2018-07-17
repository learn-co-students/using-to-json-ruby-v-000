class AuthorsController < ApplicationController
  def show
    @author = Author.find(params[:id])
    render json: @author, status: 200
  end
end
