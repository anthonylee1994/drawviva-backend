class UserSerializer < ActiveModel::Serializer
  attributes %i[id email display_name photo_url created_at updated_at]

  has_one :push_notification_subscription, if: -> { me? }

  def me?
    scope == object
  end
end
