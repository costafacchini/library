# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(current_user, _opts = {})
    if resource.persisted?
      render json: { message: 'Signed up successfully.', data: current_user.to_json }, status: :created
    else
      render json: { message: "User couldn't be created successfully. #{current_user.errors.full_messages.to_sentence}" }, status: :unprocessable_entity
    end
  end
end
