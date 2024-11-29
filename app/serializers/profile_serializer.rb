class ProfileSerializer < ActiveModel::Serializer
  attributes :id, :email, :admin
end
