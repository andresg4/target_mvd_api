class NotificationService
  def initialize(user)
    @user = user
  end

  def notify_match(devices)
    fcm = FCM.new(ENV['FIREBASE_SERVER_KEY'])
    options =
      {
        'notification':
        {
          'title': 'You have a new match',
          'user': @user.id
        }
      }
    fcm.send(devices, options)
  end
end
