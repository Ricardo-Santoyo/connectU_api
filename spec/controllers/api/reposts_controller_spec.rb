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
        repost: {
          repostable_type: "post",
          repostable_id: @post.id,
        }
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
      expect(json['data']['reposted']).to be(true)
      expect(json['data']['like_count']).to be(0)
      expect(json['data']['like_id']).to be(nil)
    end
  end
end