require 'rails_helper'
require 'faker'

describe Api::LikesController, type: :request do

  let (:user) { create_user }

  context 'When creating a comment' do
    before do
      login_with_api(user)
      @post = create_post(user)
      post "/api/likes", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        post_id: @post.id
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the like' do
      expect(json['data']['user_id']).to be(user.id)
      expect(json['data']['post_id']).to be(@post.id)
    end
  end
end