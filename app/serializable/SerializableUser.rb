class SerializableUser < JSONAPI::Serializable::Resource
  type 'users'

  attributes :name, :email, :handle, :created_at

  link :self do
    @url_helpers.api_user_url(@object.id)
  end
end