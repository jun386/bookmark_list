class Api::BookmarksController < ApplicationController
  before_action :set_bookmark, only: [:update, :destroy]
  protect_from_forgery :except => [:create, :update, :destroy]

  def index
    @bookmarks = Bookmark.order('created_at DESC')
    render "index", formats: :json, handlers: "jbuilder"
  end

  def create
    @bookmark = Bookmark.new(bookmark_params)
    if @bookmark.save
      render :show, status: :created
    else
      render json: @bookmark.errors, status: :unprocessable_entity
    end
  end

  def update
    if @bookmark.update_attributes(bookmark_params)
      render "index", formats: :json, handlers: "jbuilder"
    else
      render json: @bookmark.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @bookmark.destroy
      render json: { json: 'Bookmark was successfully deleted.'}
    else
      render json: @bookmark.errors, status: :unprocessable_entity
    end
  end

  private
    def bookmark_params
      params.require(:bookmark).permit(:title, :url, :category).merge(user_id: current_user.id)
    end

    def set_bookmark
      @bookmark = Bookmark.find(params[:id])
    end
    
end
