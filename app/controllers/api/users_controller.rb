class Api::UsersController < Api::BaseController

  before_action :find_user, only: [:show]

  def index
    @users = User.all.limit(20)
    render json: {data: include_follower_followee_info(@users)}, status: :ok
  end

  def show
    render_jsonapi_response(@user)
  end

  private

  def include_follower_followee_info(data)
    data.each do |user|
      user.uid = current_user.id
    end
    return data.as_json(methods: [:follower_followee_id])
  end

  def find_user
    @user = User.find_by_handle(params[:id])
    if !@user
      @user = User.find(params[:id])
    end
  end

end