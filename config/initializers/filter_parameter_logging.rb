# frozen_string_literal: true
# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [
  :password,
  :auth_token,
  :'auth-token',
  :'account-clearing-number',
  :'account-number',
  :iban,
  :bic
]
