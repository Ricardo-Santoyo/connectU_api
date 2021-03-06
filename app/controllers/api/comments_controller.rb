class Api::CommentsController < Api::BaseController

  include PostInfoController

  def index
    if params[:post_id] and params[:user_id]
      @comments = User.find_by_handle(params[:user_id]).posts.limit(params[:post_id].to_i).last.comments
    elsif params[:post_id]
      @comments = get_post.comments
    elsif params[:comment_id] and params[:user_id]
      @comments = User.find_by_handle(params[:user_id]).comments.limit(params[:comment_id].to_i).last.comments
    elsif params[:comment_id]
      @comments = get_comment.comments
    elsif params[:user_id]
      @comments = get_user.comments
    end
    render json: {data: include_post_info(@comments, "index")}, status: :ok
  end

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      render json: {data: include_post_info(@comment)}, status: :ok
    end
  end

  def show
    if params[:user_id]
      @comment = User.find_by_handle(params[:user_id]).comments.limit(params[:id].to_i).last
    else
      @comment = Comment.find(params[:id])
    end
    render json: {data: include_post_info(@comment)}, status: :ok
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.user_id == current_user.id
      if @comment.destroy
        render json: {data: @comment}, status: :ok
      end
    else
      render json: {title: 'Unauthorized'}, status: 401
    end
  end

  private

  def get_post
    @post = Post.find(params[:post_id])
  end

  def get_comment
    @comment = Comment.find(params[:comment_id])
  end

  def comment_params
    params[:comment][:commentable_type].capitalize!
    params.require(:comment).permit(:body, :commentable_type, :commentable_id)
  end
end