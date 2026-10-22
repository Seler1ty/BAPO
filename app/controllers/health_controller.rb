class HealthController < ApplicationController
  def show
    db_up = begin
      ActiveRecord::Base.connection.execute("SELECT 1")
      true
    rescue StandardError
      false
    end

    render json: {
      status: db_up ? "ok" : "unavailable",
      db: db_up,
      timestamp: Time.now.utc.iso8601
    }, status: (db_up ? :ok : :service_unavailable)
  end
end
