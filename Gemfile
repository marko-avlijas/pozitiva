source 'https://rubygems.org'
ruby "2.1.1"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.1'

group :development do
  # gem 'sqlite3'
  
  gem 'quiet_assets'
  # gem 'thin'
  # gem 'grizzled-rails-logger'
  gem 'rails-erd'
  gem 'pry-rails'
  
  gem 'capistrano', '~> 3.1'
  gem 'capistrano-rbenv', '~> 2.0'         # idiomatic rbenv support for capistrano
  gem 'capistrano-rbenv-install'           # ensures the right ruby version is installed
  gem 'capistrano-bundler', '~> 1.1.2'     # capistrano support for bundler
  gem 'capistrano-rails', '~> 1.0.0'       # automatic migrations and asset compilation
  gem 'capistrano-unicorn-nginx'           # plug-n-play nginx and unicorn
  gem 'capistrano-postgresql', '~> 2.0.0'  # plug-n-play postgresql
  gem 'capistrano-safe-deploy-to'          # ensures deploy path for the app exists
end

gem 'pg' #, group: :production

# for Heroku (production)
gem 'rails_12factor', group: :production

# Use unicorn as the app server (locally start with: foreman start)
# https://devcenter.heroku.com/articles/getting-started-with-rails4
# https://devcenter.heroku.com/articles/rails-unicorn
gem 'unicorn'
gem 'unicorn-worker-killer'

# Use SCSS for stylesheets
# gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
# gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 1.2'

# group :doc do
#   # bundle exec rake doc:rails generates the API under doc/api.
#   gem 'sdoc', require: false
# end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'   # already included by Devise

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

gem 'kaminari'
gem 'kaminari-bootstrap', '~> 3.0.1'
gem 'devise'
