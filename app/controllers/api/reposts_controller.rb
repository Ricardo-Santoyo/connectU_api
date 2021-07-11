class Api::RepostsController < Api::BaseController

  include PostInfoController

  def index
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

  def repost_params
    params[:repost][:repostable_type].capitalize!
    params.require(:repost).permit(:body, :repostable_type, :repostable_id)
  end
end