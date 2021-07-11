class Api::RepostsController < Api::BaseController

  include PostInfoController

  def index
    if params[:include_followees]
      ids = current_user.following.pluck(:person_id) << current_user.id
      @reposts = Repost.where(user_id: ids).order(id: :desc).limit(20)
    else
      get_user
      @reposts = @user.reposts.order(id: :desc).limit(10)
    end
    @posts = get_posts(@reposts)
    render json: {repost: get_repost_info(@reposts), data: include_post_info(@posts, "index")}, status: :ok
  end

  def create
    @repost = current_user.reposts.build(repost_params)
    if @repost.save
      render json: {repost: get_repost_info(@repost), data: include_post_info(@repost.repostable) }
    end
  end

  def destroy
    @repost = Repost.find(params[:id])
    if @repost.user_id == current_user.id
      if @repost.destroy
        render json: {data: @repost}, status: :ok
      end
    else
      render json: {title: 'Unauthorized'}, status: 401
    end
  end

  private

  def get_repost_info(data)
    return data.as_json(methods: [:user_name, :user_handle])
  end

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