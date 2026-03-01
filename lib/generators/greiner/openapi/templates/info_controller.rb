class InfoController < ActionController::API
  def show
    render json: {
      name: service_name,
      version: InfoController.version,
      description: service_description,
      homepage: homepage,
      repository: repository,
      environment: Rails.env
    }
  end

  def self.version
    v = Object.const_get("#{Rails.application.class.module_parent_name}::VERSION")
    ENV.fetch("APP_VERSION", v)
  end

  private

  def service_name
    ENV.fetch("SERVICE_NAME", Rails.application.name)
  end

  def service_description
    ENV.fetch(
      "SERVICE_DESCRIPTION",
      Rails.application.config.x.description
    )
  end

  def homepage
    ENV.fetch("SERVICE_HOMEPAGE", "https://www.kt-example.ch")
  end

  def repository
    ENV.fetch("SERVICE_REPOSITORY", "https://git.kt-example.ch/projects/example/repos/api")
  end

end
