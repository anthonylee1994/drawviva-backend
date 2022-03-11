class UserDrawSerializer < ActiveModel::Serializer
  attributes :id, :draw_id, :role, :created_at, :updated_at
  has_one :user
end
