class RegistrationsController < Devise::RegistrationsController

  def create
    begin
      build_resource(sign_up_params)
      resource.save
      sign_up(resource_name, resource) if resource.persisted?
  
      render_jsonapi_response(resource)
    rescue ActiveRecord::RecordNotUnique
      render json: {
        'errors': [
          {
            'status': '400',
            'title': 'Unique Value Violation'
          }
        ]
      }, status: 400
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end
end