class Api::UsersController < Api::BaseController

  before_action :find_user, only: [:show]

  def show
    render_jsonapi_response(@user)
  end

  private

  def find_user
    @user = User.find_by_handle(params[:id])
    if !@user
      @user = User.find(params[:id])
    end
  end

end