class Api::LikesController < Api::BaseController

  def create
    @like = current_user.likes.build(post_id: params[:post_id])
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