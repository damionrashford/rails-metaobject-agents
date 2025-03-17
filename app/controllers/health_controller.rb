class HealthController < ApplicationController
  def index
    # Check database connection
    ActiveRecord::Base.connection.execute("SELECT 1")

    # Return success response
    render json: { status: "ok", timestamp: Time.current }
  end
end
