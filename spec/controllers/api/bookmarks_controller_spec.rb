require 'rails_helper'
require 'faker'

describe Api::BookmarksController, type: :request do

  let (:user) { create_user }

  context 'When creating a bookmark' do
    before do
      login_with_api(user)
      @user2 = create_user
      @post = create_post(@user2)
      post "/api/bookmarks", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        type: "post",
        bookmarkable_id: @post.id,
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the bookmark' do
      expect(json['bookmark']['user_id']).to be(user.id)
      expect(json['bookmark']['bookmarkable_id']).to be(@post.id)
      expect(json['bookmark']['bookmarkable_type']).to eq("Post")
    end

    it 'returns the post info' do
      expect(json['data']['user_name']).to eq(@user2.name)
      expect(json['data']['user_handle']).to eq(@user2.handle)
      expect(json['data']['comment_count']).to be(0)
      expect(json['data']['commented']).to eq(false)
      expect(json['data']['repost_count']).to be(0)
      expect(json['data']['repost_id']).to be(nil)
      expect(json['data']['like_count']).to be(0)
      expect(json['data']['like_id']).to be(nil)
      expect(json['data']['bookmark_id']).to be(json['bookmark']['id'])
    end
  end

  context 'When fetching all bookmarks from a user' do
    before :each do
      @user2 = create_user
      create_bookmark(@user2, create_post(user))
      create_bookmark(user, create_post(user))
      @bookmark = create_bookmark(user, create_post(@user2))
      create_bookmark(user, create_post(user))
      login_with_api(user)
      get "/api/bookmarks", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'only returns the specified user\'s bookmarks' do
      expect(json['data'].length()).to be(3)
      expect(json['data'][1]['user_name']).to eq(@user2.name)
      expect(json['data'][1]['user_handle']).to eq(@user2.handle)
      expect(json['data'][1]['comment_count']).to be(0)
      expect(json['data'][1]['repost_count']).to be(0)
      expect(json['data'][1]['repost_id']).to be(nil)
      expect(json['data'][1]['like_count']).to be(0)
      expect(json['data'][1]['like_id']).to be(nil)
      expect(json['data'][1]['bookmark_id']).to be(@bookmark.id)
      expect(json['data'][0]['user_id']).to be(user.id)
      expect(json['data'][1]['user_id']).to be(@user2.id)
      expect(json['data'][2]['user_id']).to be(user.id)
    end
  end
end