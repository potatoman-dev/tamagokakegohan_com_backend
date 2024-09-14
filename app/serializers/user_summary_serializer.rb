class UserSummarySerializer < ActiveModel::Serializer
  attributes :name, :nickname, :avatar, :rank

  def rank
    object.rank(object.recipes)
  end
end
