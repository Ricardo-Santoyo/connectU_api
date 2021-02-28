class SerializableUser < JSONAPI::Serializable::Resource
  type 'users'

  attributes :name, :email, :handle, :created_at

  attribute :following_count do
    @object.following.count
  end

  attribute :followers_count do
    @object.followers.count
  end

  link :self do
    @url_helpers.api_user_url(@object.id)
  end
end