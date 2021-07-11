module PostInfo
  extend ActiveSupport::Concern

  attr_accessor :uid

  private

  def user_name
    return self.user.name
  end

  def user_handle
    return self.user.handle
  end

  def comment_count
    return self.comments.count
  end

  def commented
    return self.comments.exists?(user_id:uid)
  end

  def like_count
    return self.likes.count
  end

  def like_id
    return self.likes.where(user_id:uid).ids.first
  end

  def user_post_id
    return self.user.posts.find_index(self) + 1
  end

  def repost_count
    return self.reposts.count
  end

  def reposted
    return self.reposts.exists?(user_id:uid)
  end
end