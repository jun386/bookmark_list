class Api::BookmarksController < ApplicationController

  def index
    @bookmarks = Bookmark.order('created_at DESC')
    render "index", formats: :json, handlers: "jbuilder"
  end

end
