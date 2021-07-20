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
end