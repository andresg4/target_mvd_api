Devise.setup do |config|
  # The secret key used by Devise. Devise uses this key to generate
  # random tokens. Changing this key will render invalid all existing
  # confirmation, reset password and unlock tokens in the database.
  # Devise will use the `secret_key_base` as its `secret_key`
  # by default. You can change it below and use your own secret key.
  # config.secret_key = '4f084ec33a5eb9dc584369613f32d0cc59e651f69c3244aec616d2bfdca5992a20f8388edb803ba7c9a6c03f78ca07f9de018916e3a578623349659b9d8b0626'
  config.mailer_sender = 'target-mvd-api@target-mvd.com'
end
