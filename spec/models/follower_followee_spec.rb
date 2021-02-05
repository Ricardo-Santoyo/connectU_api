require 'rails_helper'

RSpec.describe FollowerFollowee, type: :model do

  let (:user1) { create_user }
  let (:user2) { create_user }

  it 'is vaild with vaild attributes' do
    expect(FollowerFollowee.new(person_id:user1.id, follower_id:user2.id)).to be_valid
  end

  it 'is not vaild without person_id' do
    expect(FollowerFollowee.new(follower_id:user2.id)).to_not be_valid
  end

  it 'is not vaild without follower_id' do
    expect(FollowerFollowee.new(person_id:user1.id)).to_not be_valid
  end

  it 'prevents duplicate record from being created' do
    create_follower_followee(user1, user2)
    expect(FollowerFollowee.new(person_id:user1.id, follower_id:user2.id)).to_not be_valid
  end

  context 'When user2 follows user1' do
    before do
      user2.following.create(person_id: user1.id)
    end

    it 'user1 has one follower' do
      expect(user1.followers.first.follower).to eq(user2)
    end

    it 'user1 has no following' do
      expect(user1.following.first).to eq(nil)
    end

    it 'user2 has one following' do
      expect(user2.following.first.person).to eq(user1)
    end

    it 'user2 has no followers' do
      expect(user2.followers.first).to eq(nil)
    end

    it 'FollowerFollowee has one record' do
      expect(FollowerFollowee.all.count).to eq(1)
    end
  end

  context 'When user2 unfollows user1' do
    before do
      @user3 = create_user
      user2.following.create(person_id: @user3.id)
      user2.following.create(person_id: user1.id)
      user2.following.last.destroy
    end

    it 'user1 has no followers' do
      expect(user1.followers.first).to eq(nil)
    end

    it 'user1 has no following' do
      expect(user1.following.first).to eq(nil)
    end

    it 'user2 has one following' do
      expect(user2.following.first.person).to eq(@user3)
    end

    it 'user2 only has one following' do
      expect(user2.following.count).to eq(1)
    end

    it 'user2 has no followers' do
      expect(user2.followers.first).to eq(nil)
    end

    it 'user3 has one follower' do
      expect(@user3.followers.first.follower).to eq(user2)
    end

    it 'user3 only has one follower' do
      expect(@user3.followers.count).to eq(1)
    end

    it 'user3 has no following' do
      expect(@user3.following.first).to eq(nil)
    end

    it 'FollowerFollowee has one record' do
      expect(FollowerFollowee.all.count).to eq(1)
    end
  end
end
