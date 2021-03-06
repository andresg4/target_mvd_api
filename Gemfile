source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'activeadmin', '~> 1.4', '>= 1.4.1'
gem 'devise_token_auth', '~> 0.2.0'
gem 'dotenv-rails', '~> 2.5'
gem 'fcm', '~> 0.0.6'
gem 'geokit-rails', '~> 2.3', '>= 2.3.1'
gem 'koala', '~> 3.0'
gem 'webmock', '~> 3.4', '>= 3.4.2'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', '~> 1.0', '>= 1.0.2'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.8'
  gem 'factory_bot_rails', '~> 4.11', '>= 4.11.1'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'letter_opener', '~> 1.6'
  gem 'rubocop', '~> 0.59.2'
  gem 'reek', '~> 5.1'
  gem 'rails_best_practices', '~> 1.19', '>= 1.19.3'
end

group :test do
  # gem 'faker', '~> 1.9', '>= 1.9.1'
  gem 'shoulda-matchers', '~> 4.0.0.rc1'
  gem 'database_cleaner', '~> 1.7'
  gem 'action-cable-testing', '~> 0.3.3'
  gem 'faker', '~> 1.9', '>= 1.9.1'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
