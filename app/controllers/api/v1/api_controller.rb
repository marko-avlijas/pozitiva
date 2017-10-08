class Api::V1::ApiController < ActionController::Base
  before_filter :authenticate_user_with_http_token!
  protect_from_forgery with: :null_session

  rescue_from "Exception", with: :something_went_wrong if Rails.env.production?

  protected

  def authenticate_user_with_http_token!
    authenticate_or_request_with_http_token do |token, options|
      api_user = User.find_by(api_key: token.to_s) if token.present?
      sign_in(api_user) if api_user
    end
  end

  def something_went_wrong(exception)
    logger.error "[ApiController] Exception: #{exception.inspect}"
    render text: "Ooops, something went wrong", status: 500
  end
end
