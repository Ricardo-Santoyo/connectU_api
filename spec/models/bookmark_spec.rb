require 'rails_helper'

RSpec.describe Bookmark, type: :model do

  let (:user) { create_user }
  let (:post) { create_post(create_user) }
  let (:comment) { create_comment(create_user, post) }

  it 'is vaild with vaild attributes(1)' do
    expect(Bookmark.new(user_id:user.id, bookmarkable_type:'Post', bookmarkable_id:post.id)).to be_valid
  end

  it 'is vaild with vaild attributes(2)' do
    expect(Bookmark.new(user_id:user.id, bookmarkable_type:'Comment', bookmarkable_id:comment.id)).to be_valid
  end

  it 'is not vaild without user_id' do
    expect(Bookmark.new(bookmarkable_type:'Post', bookmarkable_id:post.id)).to_not be_valid
  end

  it 'is not vaild without bookmarkable_type' do
    expect(Bookmark.new(user_id:user.id, bookmarkable_id:post.id)).to_not be_valid
  end

  it 'is not vaild without bookmarkable_id' do
    expect(Bookmark.new(user_id:user.id, bookmarkable_type:'Comment')).to_not be_valid
  end

  it 'prevents duplicate record from being created' do
    create_bookmark(user, comment, "Comment")
    expect(Bookmark.new(user_id:user.id, bookmarkable_type:'Comment', bookmarkable_id:comment.id)).to_not be_valid
  end

  context 'When user bookmarks a post or comment' do
    before do
      user.bookmarks.create(bookmarkable_type:'Post', bookmarkable_id:post.id)
      user.bookmarks.create(bookmarkable_type:'Comment', bookmarkable_id:comment.id)
    end

    it 'user has two bookmarks' do
      expect(user.bookmarks.first.bookmarkable).to eq(post)
      expect(user.bookmarks.last.bookmarkable).to eq(comment)
    end

    it 'post has one bookmark' do
      expect(post.bookmarks.first.user).to eq(user)
    end

    it 'comment has one bookmark' do
      expect(comment.bookmarks.first.user).to eq(user)
    end

    it 'Bookmark has two records' do
      expect(Bookmark.all.count).to eq(2)
    end
  end

  context 'When user removes a Bookmark' do
    before do
      user.bookmarks.create(bookmarkable_type:'Post', bookmarkable_id:post.id)
      user.bookmarks.create(bookmarkable_type:'Comment', bookmarkable_id:comment.id)
      user.bookmarks.last.destroy
    end

    it 'user has one Bookmark' do
      expect(user.bookmarks.first.bookmarkable).to eq(post)
      expect(user.bookmarks.last.bookmarkable).to eq(post)
    end

    it 'post has one Bookmark' do
      expect(post.bookmarks.first.user).to eq(user)
    end

    it 'comment has no Bookmarks' do
      expect(comment.bookmarks.first).to eq(nil)
    end

    it 'Bookmark has one record' do
      expect(Bookmark.all.count).to eq(1)
    end
  end
end
