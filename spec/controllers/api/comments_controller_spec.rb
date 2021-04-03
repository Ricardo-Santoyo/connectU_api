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
          commentable_type: "Post",
          commentable_id: @post.id,
          body: @body
        }
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the comment' do
      expect(json['data']['user_id']).to be(user.id)
      expect(json['data']['commentable_id']).to be(@post.id)
      expect(json['data']['commentable_type']).to eq("Post")
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
      expect(json['data'][0]['commentable_id']).to be(@post1.id)
      expect(json['data'][1]['user_id']).to be(user.id)
      expect(json['data'][1]['commentable_id']).to be(@post2.id)
      expect(json['data'][2]['user_id']).to be(user.id)
      expect(json['data'][2]['commentable_id']).to be(@post3.id)
      expect(json['data'][2]['commentable_type']).to eq("Post")
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
      @comment = create_comment(user, @post1)
      @like = create_like(user, @comment, "Comment")

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
      expect(json['data'][0]['commentable_id']).to be(@post1.id)
      expect(json['data'][1]['commentable_id']).to be(@post1.id)
      expect(json['data'][2]['commentable_id']).to be(@post1.id)
      expect(json['data'][2]['commentable_type']).to eq("Post")
    end

    it 'returns comment info' do
      expect(json['data'][3]['user_name']).to eq(user.name)
      expect(json['data'][3]['user_handle']).to eq(user.handle)
      expect(json['data'][3]['comment_count']).to be(nil)
      expect(json['data'][3]['like_count']).to be(1)
      expect(json['data'][3]['like_id']).to be(@like.id)
    end
  end

  context 'When fetching a comment from a post' do
    before :each do
      @post1 = create_post(user)
      @post2 = create_post(user)
      create_comment(create_user, @post1)
      create_comment(create_user, @post2)
      create_comment(create_user, @post2)
      @comment = create_comment(user, @post2)
      create_comment(user, @post1)

      login_with_api(user)
      get "/api/comments/#{@comment.id}", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'only returns the specified comment' do
      expect(json['data']['user_id']).to be(user.id)
      expect(json['data']['commentable_id']).to be(@post2.id)
      expect(json['data']['commentable_type']).to eq("Post")
      expect(json['data']['body']).to eq(@comment.body)
    end
  end

  context 'When a comment is missing' do
    before do
      login_with_api(user)

      get "/api/comments/1", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 404' do
      expect(response.status).to eq(404)
    end
  end

  context 'When deleting a comment' do
    before do
      login_with_api(user)
      @post = create_post(user)
      @comment = create_comment(user, @post)
      create_comment(create_user, @post)

      delete "/api/comments/#{@comment.id}", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the deleted post' do
      expect(json['data']['user_id']).to be(user.id)
      expect(json['data']['commentable_id']).to be(@post.id)
      expect(json['data']['commentable_type']).to eq("Post")
      expect(json['data']['body']).to eq(@comment.body)
    end
  end

  context 'When trying to delete another user\'s comment' do
    before do
      login_with_api(user)
      @post = create_post(user)
      create_comment(user, @post)
      @comment = create_comment(create_user, @post)

      delete "/api/comments/#{@comment.id}", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end
  end
end