class Api::PostsController < Api::BaseController

  before_action :get_user, only: [:index, :show, :create, :destroy]

  def index
    if params[:include_followees] && @user.id == current_user.id
      ids = @user.following.pluck(:person_id) << @user.id
      @posts = Post.where(user_id: ids).order(id: :desc).limit(20)
    else
      @posts = @user.posts.order(id: :desc).limit(20)
    end
    render json: {data: include_post_info(@posts, "index")}, status: :ok
  end

  def create
    @post = @user.posts.build(post_params)
    if @user.id == current_user.id
      if @post.save
        render json: {data: include_post_info(@post)}, status: :ok
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
      render json: {data: include_post_info(@post, true)}, status: :ok
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

  def include_post_info(data, like_id = nil)
    if like_id
      if like_id == "index"
        data.each do |post|
          post.uid = current_user.id
        end
      else
        data.uid = current_user.id
      end
      return data.as_json(methods: [:user_name, :user_handle, :comment_count, :commented, :like_count, :like_id])
    else
      return data.as_json(methods: [:user_name, :user_handle, :comment_count, :commented, :like_count])
    end
  end

  def get_user
    @user = User.find_by_handle(params[:user_id])
    if !@user
      @user = User.find(params[:user_id])
    end
  end

  def get_post
    @post = @user.posts.offset(params[:id].to_i - 1).first
  end

  def post_params
    params.require(:post).permit(:body)
  end

end