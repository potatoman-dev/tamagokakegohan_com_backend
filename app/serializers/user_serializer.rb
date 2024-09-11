class UserSerializer < ActiveModel::Serializer
  attributes :name, :nickname, :avatar, :introduction, :rank, :following_count, :follower_count

  def rank
    "かけだし"
  end

  def following_count
    object.followings.count
  end

  def follower_count
    object.followers.count
  end
end