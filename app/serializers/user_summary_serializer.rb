class UserSummarySerializer < ActiveModel::Serializer
  attributes :name, :nickname, :avatar
end
