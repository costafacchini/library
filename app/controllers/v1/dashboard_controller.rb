# frozen_string_literal: true

class V1::DashboardController < APIController
  def index
    # Time.current.utc.to_date
    dashboard = Dashboard.new(current_user, Date.new(2024, 6, 27))

    render json: dashboard.data, status: :ok
  end
end
