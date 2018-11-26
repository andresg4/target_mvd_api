class NotificationService
  def initialize(user)
    @user = user
  end

  def notify_user(devices, title, message)
    fcm = FCM.new(ENV['FIREBASE_SERVER_KEY'])
    options =
      {
        'notification':
        {
          'title': title,
          'body': message,
          'user': @user.id
        }
      }
    fcm.send(devices, options)
  end
end
