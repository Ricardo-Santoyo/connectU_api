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

  context 'When unfollowing a user' do
    before do
      login_with_api(user)
      @user2 = create_user
      @following = create_follower_followee(@user2, user)

      delete "/api/following/#{@following.id}", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the unfollowing' do
      expect(json['data']['follower_id']).to be(user.id)
      expect(json['data']['person_id']).to be(@user2.id)
      expect(json['data']['id']).to be(@following.id)
    end
  end

  context 'When trying to unfollow a diffrent user\'s following' do
    before do
      login_with_api(user)
      @user2 = create_user
      @following = create_follower_followee(user, @user2)

      delete "/api/following/#{@following.id}", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end
  end
end