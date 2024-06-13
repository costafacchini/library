class APIController < ApplicationController
  include Pundit::Authorization

  before_action :check_authorization # Pundit
  after_action :verify_authorized # Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def check_authorization
    authorize self
  end

  def user_not_authorized
    head :forbidden
  end
end
