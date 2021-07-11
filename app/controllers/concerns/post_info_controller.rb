module PostInfoController
  extend ActiveSupport::Concern

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

  def get_user
    @user = User.find_by_handle(params[:user_id])
    if !@user
      @user = User.find(params[:user_id])
    end
  end
end