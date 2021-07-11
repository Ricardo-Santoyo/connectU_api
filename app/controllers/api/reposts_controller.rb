class Api::RepostsController < Api::BaseController

  include PostInfoController

  def index
    get_user
    @reposts = @user.reposts.order(id: :desc).limit(10)
    @posts = get_posts(@reposts)
    render json: {repost: @reposts, data: include_post_info(@posts, "index")}, status: :ok
  end

  def create
    @repost = current_user.reposts.build(repost_params)
    if @repost.save
      render json: {repost: @repost, data: include_post_info(@repost.repostable) }
    end
  end

  def destroy
  end

  private

  def get_posts(data)
    new_data = []
    data.each do |repost|
      new_data << repost.repostable
    end
    return new_data
  end

  def repost_params
    params[:repost][:repostable_type].capitalize!
    params.require(:repost).permit(:body, :repostable_type, :repostable_id)
  end
end