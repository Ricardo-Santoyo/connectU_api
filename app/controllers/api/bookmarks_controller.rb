class Api::BookmarksController < Api::BaseController

  include PostInfoController

  def index
    @bookmarks = current_user.bookmarks.order(id: :desc).limit(20)
    @posts = get_posts(@bookmarks)
    render json: {bookmark: @bookmarks, data: include_post_info(@posts, "index")}, status: :ok
  end

  def create
    @bookmark = current_user.bookmarks.build(bookmarkable_type: params[:type].capitalize, bookmarkable_id: params[:bookmarkable_id])
    if @bookmark.save
      render json: {bookmark: @bookmark, data: include_post_info(@bookmark.bookmarkable) }
    end
  end

  private

  def get_posts(data)
    new_data = []
    data.each do |bookmark|
      new_data << bookmark.bookmarkable
    end
    return new_data
  end
end