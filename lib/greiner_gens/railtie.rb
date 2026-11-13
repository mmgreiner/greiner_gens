# frozen_string_literal: true

require "rails/railtie"

module GreinerGens
  class Railtie < Rails::Railtie
    generators do
      require "generators/greiner/slim/slim_generator"
      require "generators/greiner/simplecss/simplecss_generator"
      require "generators/greiner/openapi/openapi_generator"
      require "generators/greiner/entraid/entraid_generator"
    end
    rake_tasks do
      load File.expand_path("../tasks/docker.rake", __dir__)
    end
  end
end
