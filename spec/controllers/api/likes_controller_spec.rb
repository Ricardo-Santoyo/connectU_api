require 'rails_helper'
require 'faker'

describe Api::LikesController, type: :request do

  let (:user) { create_user }

  context 'When creating a like' do
    before do
      login_with_api(user)
      @post = create_post(user)
      post "/api/likes", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        type: "Post",
        likeable_id: @post.id
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the like' do
      expect(json['data']['user_id']).to be(user.id)
      expect(json['data']['likeable_id']).to be(@post.id)
      expect(json['data']['likeable_type']).to eq("Post")
    end
  end

  context 'When trying to create a duplicate like' do
    before do
      login_with_api(user)
      @post = create_post(user)
      create_like(user, @post)

      post "/api/likes", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        type: "Post",
        likeable_id: @post.id
      }
    end

    it 'returns 400' do
      expect(response.status).to eq(400)
    end
  end

  context 'When deleting a like' do
    before do
      login_with_api(user)
      @post = create_post(user)
      @like = create_like(user, @post)
      create_like(create_user, @post)

      delete "/api/likes/#{@like.id}", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the deleted like' do
      expect(json['data']['user_id']).to be(user.id)
      expect(json['data']['likeable_id']).to be(@post.id)
      expect(json['data']['likeable_type']).to eq("Post")
      expect(json['data']['id']).to be(@like.id)
    end
  end

  context 'When trying to delete another user\'s like' do
    before do
      login_with_api(user)
      @post = create_post(user)
      create_like(user, @post)
      @like = create_like(create_user, @post)

      delete "/api/likes/#{@like.id}", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end
  end
end