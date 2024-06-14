# frozen_string_literal: true

class V1::DashboardController < APIController
  def index
    dashboard = Dashboard.new(current_user, Time.current.utc.to_date)

    render json: dashboard.data, status: :ok
  end
end
