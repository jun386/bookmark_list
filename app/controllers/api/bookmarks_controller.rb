class Api::BookmarksController < ApplicationController
  before_action :set_bookmark, only: [:update, :destroy]
  protect_from_forgery :except => [:create, :update, :destroy]

  def index
    page = params[:page] || 1
    per = params[:per] || 30

    @bookmarks = Bookmark.where(user_id: current_user.id).order('created_at DESC').page(page).per(per)
    total_pages = @bookmarks.total_pages

    response = {
      bookmarks: @bookmarks,
      total_pages: total_pages,
    }
    render json: response
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
