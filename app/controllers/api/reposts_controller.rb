class Api::RepostsController < Api::BaseController

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

  def include_post_info(data, action = nil)
    if action == "index"
      data.each do |post|
        post.uid = current_user.id
      end
    else
      data.uid = current_user.id
    end
    return data.as_json(methods: [:user_name, :user_handle, :comment_count, :commented, :like_count, :like_id, :user_post_id, :repost_count, :reposted])
  end

  def repost_params
    params[:repost][:repostable_type].capitalize!
    params.require(:repost).permit(:body, :repostable_type, :repostable_id)
  end
end