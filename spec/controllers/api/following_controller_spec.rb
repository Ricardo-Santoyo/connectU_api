require 'rails_helper'
require 'faker'

describe Api::FollowingController, type: :request do

  let (:user) { create_user }

  context 'When following a user' do
    before do
      login_with_api(user)
      @user2 = create_user
      post "/api/following", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        person_id: @user2.id
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the following' do
      expect(json['data']['follower_id']).to be(user.id)
      expect(json['data']['person_id']).to be(@user2.id)
    end
  end
=begin
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
      expect(json['data']['post_id']).to be(@post.id)
      expect(json['data']['id']).to be(@like.id)
    end
  end
=end
end