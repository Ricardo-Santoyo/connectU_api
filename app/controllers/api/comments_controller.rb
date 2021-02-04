class Api::CommentsController < Api::BaseController

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      render json: {data: @comment}, status: :ok
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :post_id)
  end
end