require 'rails_helper'
require 'faker'

describe Api::CommentsController, type: :request do

  let (:user) { create_user }

  context 'When creating a comment' do
    before do
      login_with_api(user)
      @post = create_post(user)
      @body = Faker::Lorem.sentence
      post "/api/comments", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        comment: {
          post_id: @post.id,
          body: @body
        }
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the comment' do
      expect(json['data']['user_id']).to be(user.id)
      expect(json['data']['post_id']).to be(@post.id)
      expect(json['data']['body']).to eq(@body)
    end
  end
end