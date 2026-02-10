# frozen_string_literal: true

require 'rails/railtie'

module GreinerGens
  class Railtie < Rails::Railtie
    generators do
      require 'generators/greiner/slim/slim_generator'
      require 'generators/greiner/simplecss/simplecss_generator'
    end
  end
end
