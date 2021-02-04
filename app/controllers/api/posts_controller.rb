class Api::PostsController < Api::BaseController

  before_action :get_user, only: [:index, :show, :destroy]

  def index
    @posts = @user.posts
    render json: {data: @posts}, status: :ok
  end

  def create
    @post = Post.new(post_params)
    if @post.user_id == current_user.id
      if @post.save
        render json: {data: @post}, status: :ok
      end
    else
      render json: {title: 'Unauthorized'}, status: 401
    end
  end

  def show
    get_post
    if @post == nil
      render json: {title:'Not Found'}, status: 404
    else
      render json: {data: @post}, status: :ok
    end
  end

  def destroy
    get_post
    if @post == nil
      render json: {title:'Not Found'}, status: 404
    else
      if @post.user_id == current_user.id
        if @post.destroy
          render json: {data: @post}, status: :ok
        end
      else
        render json: {title: 'Unauthorized'}, status: 401
      end
    end
  end

  private

  def get_user
    @user = User.find(params[:user_id])
  end

  def get_post
    @post = @user.posts.offset(params[:id].to_i - 1).first
  end

  def post_params
    params.require(:post).permit(:body, :user_id)
  end

end