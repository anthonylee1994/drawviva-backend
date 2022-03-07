class NotificationService
  def self.send(subscription, message)
    Webpush.payload_send(
      message:,
      endpoint: subscription.endpoint,
      p256dh: subscription.p256dh,
      auth: subscription.auth,
      vapid: {
        subject: Settings.webpush.subject,
        public_key: Settings.webpush.public_key,
        private_key: Settings.webpush.private_key
      },
      ssl_timeout: 5,
      open_timeout: 5,
      read_timeout: 5
    )
  end
end
