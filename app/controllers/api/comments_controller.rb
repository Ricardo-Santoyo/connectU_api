class Api::CommentsController < Api::BaseController

  def index
    if params[:post_id]
      @comments = get_post.comments
    elsif params[:user_id]
      @comments = get_user.comments
    end
    render json: {data: @comments}, status: :ok
  end

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      render json: {data: @comment}, status: :ok
    end
  end

  private

  def get_post
    @post = Post.find(params[:post_id])
  end

  def get_user
    @user = User.find(params[:user_id])
  end

  def comment_params
    params.require(:comment).permit(:body, :post_id)
  end
end