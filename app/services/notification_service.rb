class NotificationService
  def self.send(subscription, message)
    Webpush.payload_send(
      message: message.to_json,
      endpoint: subscription.endpoint,
      p256dh: subscription.p256dh,
      auth: subscription.auth,
      vapid: {
        subject: ENV['WEBPUSH_SUBJECT'],
        public_key: ENV['WEBPUSH_PUBLIC_KEY'],
        private_key: ENV['WEBPUSH_PRIVATE_KEY']
      },
      ssl_timeout: 5,
      open_timeout: 5,
      read_timeout: 5
    )
  end
end
