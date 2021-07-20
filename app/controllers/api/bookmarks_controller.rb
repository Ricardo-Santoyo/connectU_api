class Api::BookmarksController < Api::BaseController

  include PostInfoController

  def create
    @bookmark = current_user.bookmarks.build(bookmarkable_type: params[:type].capitalize, bookmarkable_id: params[:bookmarkable_id])
    if @bookmark.save
      render json: {bookmark: @bookmark, data: include_post_info(@bookmark.bookmarkable) }
    end
  end
end