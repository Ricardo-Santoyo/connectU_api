require 'rails_helper'

RSpec.describe Repost, type: :model do

  let (:user) { create_user }
  let (:post) { create_post(create_user) }
  let (:comment) { create_comment(create_user, post) }

  it 'is vaild with vaild attributes(1)' do
    expect(Repost.new(user_id:user.id, repostable_type:'Post', repostable_id:post.id)).to be_valid
  end

  it 'is vaild with vaild attributes(2)' do
    expect(Repost.new(user_id:user.id, repostable_type:'Comment', repostable_id:comment.id)).to be_valid
  end

  it 'is not vaild without user_id' do
    expect(Repost.new(repostable_type:'Post', repostable_id:post.id)).to_not be_valid
  end

  it 'is not vaild without repostable_type' do
    expect(Repost.new(user_id:user.id, repostable_id:post.id)).to_not be_valid
  end

  it 'is not vaild without repostable_id' do
    expect(Repost.new(user_id:user.id, repostable_type:'Comment')).to_not be_valid
  end

  it 'prevents duplicate record from being created' do
    create_repost(user, comment, "Comment")
    expect(Repost.new(user_id:user.id, repostable_type:'Comment', repostable_id:comment.id)).to_not be_valid
  end

  context 'When user reposts a post or comment' do
    before do
      user.reposts.create(repostable_type:'Post', repostable_id:post.id)
      user.reposts.create(repostable_type:'Comment', repostable_id:comment.id)
    end

    it 'user has two repost' do
      expect(user.reposts.first.repostable).to eq(post)
      expect(user.reposts.last.repostable).to eq(comment)
    end

    it 'post has one repost' do
      expect(post.reposts.first.user).to eq(user)
    end

    it 'comment has one repost' do
      expect(comment.reposts.first.user).to eq(user)
    end

    it 'Repost has two record' do
      expect(Repost.all.count).to eq(2)
    end
  end

  context 'When user removes a repost' do
    before do
      user.reposts.create(repostable_type:'Post', repostable_id:post.id)
      user.reposts.create(repostable_type:'Comment', repostable_id:comment.id)
      user.reposts.last.destroy
    end

    it 'user has one repost' do
      expect(user.reposts.first.repostable).to eq(post)
      expect(user.reposts.last.repostable).to eq(post)
    end

    it 'post has one repost' do
      expect(post.reposts.first.user).to eq(user)
    end

    it 'comment has no reposts' do
      expect(comment.reposts.first).to eq(nil)
    end

    it 'Repost has one record' do
      expect(Repost.all.count).to eq(1)
    end
  end
end
