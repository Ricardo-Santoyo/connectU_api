class Api::FollowingController < Api::BaseController

  def create
    @following = current_user.following.build(person_id: params[:person_id])
    if @following.save
      render json: {data: @following}, status: :ok
    end
  end

  def destroy
    @following = FollowerFollowee.find(params[:id])
    if @following.follower_id == current_user.id
      if @following.destroy
        render json: {data: @following}, status: :ok
      end
    else
      render json: {title: 'Unauthorized'}, status: 401
    end
  end

end