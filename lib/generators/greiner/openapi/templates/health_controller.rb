class HealthController < ActionController::API
  def live
    head :ok
  end

  def ready
    if ready?
      head :ok
    else
      render_problem(
        status: 503,
        title: "Service Unavailable",
        detail: "One or more dependencies are unavailable"
      )
    end
  end

  def health
    health_status = build_health_status

    if health_status[:status] == "UP"
      render json: health_status, status: :ok
    else
      render json: health_status, status: :service_unavailable
    end
  end

  private

  def ready?
    database_ready?
  end

  def database_ready?
    # ActiveRecord::Base.connection.active?
    ActiveRecord::Base.connection.execute("SELECT 1").any?
  rescue StandardError
    false
  end

  def build_health_status
    dependencies = {
      database: database_ready? ? "UP" : "DOWN"
    }
    overall_status = dependencies.values.all? { |v| v == "UP" } ? "UP" : "DOWN"

    {
      status: overall_status,
      timestamp: Time.current.iso8601,
      version: HealthController.app_version,
      dependencies: dependencies
    }
  end

  def render_problem(status:, title:, detail:)
    render json: {
      type: "about:blank",
      title: title,
      status: status,
      detail: detail,
      instance: request.path
    },
    status: status,
    content_type: "application/problem+json"
  end
end
