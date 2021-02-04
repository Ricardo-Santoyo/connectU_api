class Api::LikesController < Api::BaseController

  def create
    @like = current_user.likes.build(post_id: params[:post_id])
    if @like.save
      render json: {data: @like}, status: :ok
    end
  end

  def destroy

  end

end