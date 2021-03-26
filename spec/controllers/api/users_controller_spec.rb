require 'rails_helper'

describe Api::UsersController, type: :request do

  let (:user) { create_user }

  context 'When fetching a user' do
    before do
      login_with_api(user)
      get "/api/users/#{user.id}", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the user' do
      expect(json['data']).to have_id(user.id.to_s)
      expect(json['data']).to have_type('users')
      expect(json['data']['attributes']['following_count']).to be(0)
      expect(json['data']['attributes']['followers_count']).to be(0)
    end
  end

  context 'When fetching a user with user handle' do
    before do
      login_with_api(user)
      @user2 = create_user
      @following = create_follower_followee(@user2, user)
      get "/api/users/#{@user2.handle}", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the user' do
      expect(json['data']).to have_id(@user2.id.to_s)
      expect(json['data']).to have_type('users')
      expect(json['data']['attributes']['following_count']).to be(0)
      expect(json['data']['attributes']['followers_count']).to be(1)
      expect(json['data']['attributes']['follower_followee_id']).to be(@following.id)
    end
  end

  context 'When a user is missing' do
    before do
      login_with_api(user)
      get "/api/users/blank", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 404' do
      expect(response.status).to eq(404)
    end
  end

  context 'When the Authorization header is missing' do
    before do
      get "/api/users/#{user.id}"
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end
  end

  context 'When fetching users' do
    before do
      login_with_api(user)
      @user2 = create_user
      @following = create_follower_followee(@user2, user)
      create_user
      create_user
      create_user
      get "/api/users", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the users' do
      expect(json['data'][0]['id']).to be(user.id)
      expect(json['data'][1]['follower_followee_id']).to be(@following.id)
      expect(json['data'].length()).to be(5)
    end
  end
end