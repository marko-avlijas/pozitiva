# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
# Pozitiva::Application.config.secret_key_base = '45e079e4f549d428604d97451e5de4a4ad388333043dc963d385fdab17d46870004cddc6a2139858a75fe0738f9fd0497002368f864227e65a4825892a68dd8f'

Pozitiva::Application.config.secret_key_base = ENV['APP_SECRET_KEY'] || '45e079e4f549d428604d97451e5de4a4ad388333043dc963d385fdab17d46870004cddc6a2139858a75fe0738f9fd0497002368f864227e65a4825892a68dd8f'