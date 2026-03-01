# frozen_string_literal: true

module Greiner
  # Rails generator to add simplecss css framework to a rails application
  class OpenapiGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    desc 'Add a standard OpenAPI spec and middleware to a rails application'

    def add_committee_gem
      gem 'committee', groups: [:development, :test]
      run 'bundle install'
    end

    def configure_openapi
      %w[info_controller.rb health_controller.rb].each do |f|
        template f, "app/controllers/#{f}"
      end
      copy_file "openapi.yaml", "openapi/openapi.yaml"
    end

    def configure_version
      template "version.rb", "config/version.rb", skip: true
    end
    
    def configure_routes
      routes = <<~ROUTES.indent(2)
        # openapi
        get "/live",   to: "health#live"
        get "/ready",  to: "health#ready"
        get "/health", to: "health#health"
        get "/info",   to: "info#show"
      ROUTES
      inject_into_file "config/routes.rb", routes, before: /^end/
    end

    def configure_environments
      config = <<~CONFIG.indent(2)

        # Greiner
        config.middleware.use(Committee::Middleware::ResponseValidation,
          schema_path: Rails.root.join("openapi/openapi.yaml").to_s,
          strict: true
        )
      CONFIG
      %w[development.rb test.rb].each do |f|
        inject_into_file "config/environments/#{f}", config, before: /^end/
      end
    end
  end
end
