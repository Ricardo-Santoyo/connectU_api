class Api::FollowingController < Api::BaseController

  def create
    @following = current_user.following.build(person_id: params[:person_id])
    if @following.save
      render json: {data: @following}, status: :ok
    end
  end

  def destroy
  end

end