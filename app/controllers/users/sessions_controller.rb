# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(current_user, _opts = {})
    render json: { message: 'Logged in successfully.', data: { user: current_user.to_json } }, status: :ok
  end

  def respond_to_on_destroy
    if request.headers['Authorization'].present?
      jwt_payload = JWT.decode(
          request.headers['Authorization'].split(' ').last,
          Rails.application.credentials.devise_jwt_secret_key!
      ).first
      current_user = User.find(jwt_payload['sub'])
    end

    if current_user
      render json: { message: 'Logged out successfully.' }, status: :ok
    else
      render json: { message: "Couldn't find an active session." }, status: :unauthorized
    end
  end
end
