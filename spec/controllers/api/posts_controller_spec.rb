require 'rails_helper'
require 'faker'

describe Api::PostsController, type: :request do

  let (:user) { create_user }

  context 'When creating a post' do
    before do
      login_with_api(user)
      @body = Faker::String.random
      post "/api/users/#{user.id}/posts", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        post: {
          body: @body
        }
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the post' do
      expect(json['data']['user_name']).to eq(user.name)
      expect(json['data']['user_handle']).to eq(user.handle)
      expect(json['data']['user_id']).to be(user.id)
      expect(json['data']['body']).to eq(@body)
      expect(json['data']['comment_count']).to be(0)
      expect(json['data']['like_count']).to be(0)
    end
  end

  context 'When trying to create a post for a different user' do
    before do
      @body = Faker::String.random
      @user2 = create_user
      login_with_api(@user2)
      post "/api/users/#{user.id}/posts", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        post: {
          body: @body
        }
      }
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end
  end

  context 'When fetching all posts from a user' do
    before :each do
      create_post(create_user)
      create_post(user)
      create_post(user)
      create_post(user)
      login_with_api(user)
      get "/api/users/#{user.id}/posts", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'only returns the specified user\'s posts' do
      expect(json['data'].length()).to be(3)
      expect(json['data'][1]['user_name']).to eq(user.name)
      expect(json['data'][1]['user_handle']).to eq(user.handle)
      expect(json['data'][1]['comment_count']).to be(0)
      expect(json['data'][1]['like_count']).to be(0)
      expect(json['data'][1]['like_id']).to be(nil)
      expect(json['data'][0]['user_id']).to be(user.id)
      expect(json['data'][1]['user_id']).to be(user.id)
      expect(json['data'][2]['user_id']).to be(user.id)
    end
  end

  context 'When fetching all posts from a user using their handle' do
    before :each do
      create_post(create_user)
      create_post(user)
      create_post(user)
      create_post(user)
      login_with_api(user)
      get "/api/users/#{user.handle}/posts", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'only returns the specified user\'s posts' do
      expect(json['data'].length()).to be(3)
      expect(json['data'][1]['user_name']).to eq(user.name)
      expect(json['data'][1]['user_handle']).to eq(user.handle)
      expect(json['data'][1]['comment_count']).to be(0)
      expect(json['data'][1]['like_count']).to be(0)
      expect(json['data'][1]['like_id']).to be(nil)
      expect(json['data'][0]['user_id']).to be(user.id)
      expect(json['data'][1]['user_id']).to be(user.id)
      expect(json['data'][2]['user_id']).to be(user.id)
      expect(json['data'][1]['user_post_id']).to be(2)
    end
  end

  context 'When fetching all posts from another user' do
    before :each do
      @user2 = create_user
      create_post(user)
      create_post(@user2)
      create_post(@user2)
      create_post(@user2)
      login_with_api(user)
      get "/api/users/#{@user2.id}/posts", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'only returns the specified user\'s posts' do
      expect(json['data'].length()).to be(3)
      expect(json['data'][0]['user_name']).to eq(@user2.name)
      expect(json['data'][0]['user_handle']).to eq(@user2.handle)
      expect(json['data'][0]['comment_count']).to be(0)
      expect(json['data'][0]['like_count']).to be(0)
      expect(json['data'][0]['user_id']).to be(@user2.id)
      expect(json['data'][1]['user_id']).to be(@user2.id)
      expect(json['data'][2]['user_id']).to be(@user2.id)
    end
  end

  context 'When fetching all posts from a user including followees' do
    before :each do
      @user2 = create_user
      user.following.create(person_id:@user2.id)
      create_post(user)
      create_post(@user2)
      create_post(user)
      create_post(user)
      login_with_api(user)
      get "/api/users/#{user.id}/posts", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        include_followees: true
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the posts in reverse chronological order' do
      expect(json['data'].length()).to be(4)
      expect(json['data'][0]['user_handle']).to eq(user.handle)
      expect(json['data'][1]['user_handle']).to eq(user.handle)
      expect(json['data'][2]['user_handle']).to eq(@user2.handle)
      expect(json['data'][3]['user_handle']).to eq(user.handle)
      expect(json['data'][3]['comment_count']).to be(0)
      expect(json['data'][3]['commented']).to eq(false)
      expect(json['data'][3]['like_count']).to be(0)
      expect(json['data'][0]['user_name']).to eq(user.name)
      expect(json['data'][1]['user_name']).to eq(user.name)
      expect(json['data'][2]['user_name']).to eq(@user2.name)
      expect(json['data'][3]['user_name']).to eq(user.name)
      expect(json['data'][0]['user_id']).to be(user.id)
      expect(json['data'][1]['user_id']).to be(user.id)
      expect(json['data'][2]['user_id']).to be(@user2.id)
      expect(json['data'][3]['user_id']).to be(user.id)
    end
  end

  context 'When trying to fetch all posts from another user including followees' do
    before :each do
      @user2 = create_user
      @user2.following.create(person_id: user.id)
      create_post(user)
      create_post(@user2)
      create_post(user)
      create_post(user)
      login_with_api(user)
      get "/api/users/#{@user2.id}/posts", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        include_followees: true
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'only returns the specified user\'s posts' do
      expect(json['data'].length()).to be(1)
      expect(json['data'][0]['user_handle']).to eq(@user2.handle)
      expect(json['data'][0]['user_name']).to eq(@user2.name)
      expect(json['data'][0]['user_id']).to be(@user2.id)
      expect(json['data'][0]['comment_count']).to be(0)
      expect(json['data'][0]['like_count']).to be(0)
    end
  end

  context 'When fetching a post from a user' do
    before :each do
      create_post(create_user)
      create_post(user)
      @post = create_post(user)
      login_with_api(user)
      get "/api/users/#{user.id}/posts/2", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'only returns the specified post' do
      expect(json['data']['user_handle']).to eq(user.handle)
      expect(json['data']['user_name']).to eq(user.name)
      expect(json['data']['user_id']).to be(user.id)
      expect(json['data']['comment_count']).to be(0)
      expect(json['data']['commented']).to eq(false)
      expect(json['data']['like_count']).to be(0)
      expect(json['data']['body']).to eq(@post.body)
    end
  end

  context 'When fetching a post from a user using their handle' do
    before :each do
      create_post(create_user)
      create_post(user)
      @post = create_post(user)
      login_with_api(user)
      get "/api/users/#{user.handle}/posts/2", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'only returns the specified post' do
      expect(json['data']['user_handle']).to eq(user.handle)
      expect(json['data']['user_name']).to eq(user.name)
      expect(json['data']['user_id']).to be(user.id)
      expect(json['data']['comment_count']).to be(0)
      expect(json['data']['like_count']).to be(0)
      expect(json['data']['body']).to eq(@post.body)
    end
  end

  context 'When fetching a post from another user' do
    before :each do
      @user2 = create_user
      create_post(user)
      create_post(@user2)
      @post = create_post(@user2)
      login_with_api(user)
      get "/api/users/#{@user2.id}/posts/2", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'only returns the specified post' do
      expect(json['data']['user_handle']).to eq(@user2.handle)
      expect(json['data']['user_name']).to eq(@user2.name)
      expect(json['data']['user_id']).to be(@user2.id)
      expect(json['data']['comment_count']).to be(0)
      expect(json['data']['like_count']).to be(0)
      expect(json['data']['like_id']).to be(nil)
      expect(json['data']['body']).to eq(@post.body)
    end
  end

  context 'When a post is missing' do
    before do
      login_with_api(user)

      get "/api/users/#{user.id}/posts/1", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 404' do
      expect(response.status).to eq(404)
    end
  end

  context 'When deleting a post' do
    before do
      login_with_api(user)
      @post = create_post(user)
      create_post(user)

      delete "/api/users/#{user.id}/posts/1", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the deleted post' do
      expect(json['data']['user_id']).to be(user.id)
      expect(json['data']['body']).to eq(@post.body)
    end
  end

  context 'When trying to delete another user\'s post' do
    before do
      @user2 = create_user
      create_post(@user2)
      login_with_api(user)

      delete "/api/users/#{@user2.id}/posts/1", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end
  end

  context 'When deleting a missing post' do
    before do
      login_with_api(user)

      delete "/api/users/#{user.id}/posts/1", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 404' do
      expect(response.status).to eq(404)
    end
  end
end