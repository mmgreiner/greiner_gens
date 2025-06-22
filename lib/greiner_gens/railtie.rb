require 'rails/railtie'

module GreinerGens
  class Railtie < Rails::Railtie
    generators do
      require 'generators/greiner/slim/slim_generator'
      require 'generators/greiner/simple_css/simple_css_generator'
    end
  end
end