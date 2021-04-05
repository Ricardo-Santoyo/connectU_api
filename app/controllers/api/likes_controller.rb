class Api::LikesController < Api::BaseController

  def create
    @like = current_user.likes.build(likeable_type: params[:type].capitalize, likeable_id: params[:likeable_id])
    if @like.save
      render json: {data: @like}, status: :ok
    else
      render json: {title: 'Duplicate Record'}, status: 400
    end
  end

  def destroy
    @like = Like.find(params[:id])
    if @like.user_id == current_user.id
      if @like.destroy
        render json: {data: @like}, status: :ok
      end
    else
      render json: {title: 'Unauthorized'}, status: 401
    end
  end

end