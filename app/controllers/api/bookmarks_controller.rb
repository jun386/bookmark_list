class Api::BookmarksController < ApplicationController

  protect_from_forgery :except => [:create, :update, :destroy]

  def index
    @bookmarks = Bookmark.order('created_at DESC')
    render "index", formats: :json, handlers: "jbuilder"
  end

  def create
    @bookmark = Bookmark.new(bookmark_params)
    if @bookmark.save
      head :no_content
    else
      render json: @bookmark.errors, status: :unprocessable_entity
    end
  end


  private
    def bookmark_params
      params.require(:bookmark).permit(:title, :url, :category)
    end

end
