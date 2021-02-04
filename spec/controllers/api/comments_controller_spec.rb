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

  context 'When fetching all comments from a user' do
    before :each do
      @post1 = create_post(create_user)
      create_comment(create_user, @post1)
      create_comment(user, @post1)
      @post2 = create_post(create_user)
      create_comment(user, @post2)
      @post3 = create_post(create_user)
      create_comment(user, @post3)
      login_with_api(user)
      get "/api/comments", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        user_id: user.id
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'only returns the specified user\'s comments' do
      expect(json['data'].length()).to be(3)
      expect(json['data'][0]['user_id']).to be(user.id)
      expect(json['data'][0]['post_id']).to be(@post1.id)
      expect(json['data'][1]['user_id']).to be(user.id)
      expect(json['data'][1]['post_id']).to be(@post2.id)
      expect(json['data'][2]['user_id']).to be(user.id)
      expect(json['data'][2]['post_id']).to be(@post3.id)
    end
  end

  context 'When fetching all comments from a post' do
    before :each do
      @post1 = create_post(user)
      @post2 = create_post(user)
      create_comment(create_user, @post1)
      create_comment(create_user, @post1)
      create_comment(create_user, @post1)
      create_comment(create_user, @post2)
      create_comment(user, @post1)

      login_with_api(user)
      get "/api/comments", headers: {
        'Authorization': response.headers['Authorization']
      }, params: {
        post_id: @post1.id
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'only returns the specified post\'s comments' do
      expect(json['data'].length()).to be(4)
      expect(json['data'][0]['post_id']).to be(@post1.id)
      expect(json['data'][1]['post_id']).to be(@post1.id)
      expect(json['data'][2]['post_id']).to be(@post1.id)
    end
  end
end