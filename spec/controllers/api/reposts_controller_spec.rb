require 'rails_helper'
require 'faker'

describe Api::RepostsController, type: :request do

  let (:user) { create_user }

  context 'When creating a repost' do
    before do
      login_with_api(user)
      @user2 = create_user
      @post = create_post(@user2)
      post "/api/reposts", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        repostable_type: "post",
        repostable_id: @post.id,
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the repost' do
      expect(json['repost']['user_id']).to be(user.id)
      expect(json['repost']['repostable_id']).to be(@post.id)
      expect(json['repost']['repostable_type']).to eq("Post")
    end

    it 'returns the post info' do
      expect(json['data']['user_name']).to eq(@user2.name)
      expect(json['data']['user_handle']).to eq(@user2.handle)
      expect(json['data']['comment_count']).to be(0)
      expect(json['data']['commented']).to eq(false)
      expect(json['data']['repost_count']).to be(1)
      expect(json['data']['repost_id']).to be(json['repost']['id'])
      expect(json['data']['like_count']).to be(0)
      expect(json['data']['like_id']).to be(nil)
    end
  end

  context 'When fetching all reposts from a user' do
    before :each do
      create_repost(create_user, create_post(user))
      create_repost(user, create_post(user))
      @repost = create_repost(user, create_post(user))
      create_repost(user, create_post(user))
      login_with_api(user)
      get "/api/reposts", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        user_id: user.handle
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'only returns the specified user\'s reposts' do
      expect(json['data'].length()).to be(3)
      expect(json['data'][1]['user_name']).to eq(user.name)
      expect(json['data'][1]['user_handle']).to eq(user.handle)
      expect(json['data'][1]['comment_count']).to be(0)
      expect(json['data'][1]['repost_count']).to be(1)
      expect(json['data'][1]['repost_id']).to be(@repost.id)
      expect(json['data'][1]['like_count']).to be(0)
      expect(json['data'][1]['like_id']).to be(nil)
      expect(json['data'][0]['user_id']).to be(user.id)
      expect(json['data'][1]['user_id']).to be(user.id)
      expect(json['data'][2]['user_id']).to be(user.id)
      expect(json['repost'][0]['user_id']).to be(user.id)
      expect(json['repost'][1]['user_id']).to be(user.id)
    end
  end

  context 'When fetching all reposts from another user' do
    before :each do
      @user2 = create_user
      create_repost(@user2, create_post(user))
      create_repost(user, create_post(user))
      create_repost(user, create_post(user))
      create_repost(@user2, create_post(user))
      login_with_api(user)
      get "/api/reposts", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        user_id: @user2.handle
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'only returns the specified user\'s reposts' do
      expect(json['data'].length()).to be(2)
      expect(json['data'][1]['user_name']).to eq(user.name)
      expect(json['data'][1]['user_handle']).to eq(user.handle)
      expect(json['data'][1]['comment_count']).to be(0)
      expect(json['data'][1]['repost_count']).to be(1)
      expect(json['data'][1]['repost_id']).to be(nil)
      expect(json['data'][1]['like_count']).to be(0)
      expect(json['data'][1]['like_id']).to be(nil)
      expect(json['data'][0]['user_id']).to be(user.id)
      expect(json['data'][1]['user_id']).to be(user.id)
      expect(json['repost'][0]['user_id']).to be(@user2.id)
      expect(json['repost'][1]['user_id']).to be(@user2.id)
    end
  end

  context 'When fetching all reposts from a user including followees' do
    before :each do
      @user2 = create_user
      user.following.create(person_id:@user2.id)
      @repost = create_repost(user, create_post(user))
      create_repost(@user2, create_post(user))
      create_repost(user, create_post(@user2))
      create_repost(user, create_post(user))
      login_with_api(user)
      get "/api/reposts", headers: {
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
      expect(json['data'][1]['user_handle']).to eq(@user2.handle)
      expect(json['data'][2]['user_handle']).to eq(user.handle)
      expect(json['data'][3]['user_handle']).to eq(user.handle)
      expect(json['data'][3]['comment_count']).to be(0)
      expect(json['data'][3]['commented']).to eq(false)
      expect(json['data'][3]['like_count']).to be(0)
      expect(json['data'][3]['repost_count']).to be(1)
      expect(json['data'][3]['repost_id']).to be(@repost.id)
      expect(json['data'][0]['user_name']).to eq(user.name)
      expect(json['data'][1]['user_name']).to eq(@user2.name)
      expect(json['data'][2]['user_name']).to eq(user.name)
      expect(json['data'][3]['user_name']).to eq(user.name)
      expect(json['data'][0]['user_id']).to be(user.id)
      expect(json['data'][1]['user_id']).to be(@user2.id)
      expect(json['data'][2]['user_id']).to be(user.id)
      expect(json['data'][3]['user_id']).to be(user.id)
      expect(json['repost'][0]['user_id']).to be(user.id)
      expect(json['repost'][1]['user_id']).to be(user.id)
      expect(json['repost'][2]['user_id']).to be(@user2.id)
      expect(json['repost'][3]['user_id']).to be(user.id)
    end
  end

  context 'When deleting a repost' do
    before do
      login_with_api(user)
      @post = create_post(create_user)
      @repost = create_repost(user, @post)

      delete "/api/reposts/#{@repost.id}", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the deleted repost' do
      expect(json['data']['user_id']).to be(user.id)
      expect(json['data']['repostable_id']).to be(@post.id)
      expect(json['data']['repostable_type']).to eq("Post")
      expect(json['data']['id']).to be(@repost.id)
    end
  end

  context 'When trying to delete another user\'s repost' do
    before do
      login_with_api(user)
      @post = create_post(user)
      @repost = create_repost(create_user, @post)

      delete "/api/reposts/#{@repost.id}", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end
  end
end