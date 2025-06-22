require 'rails/railtie'

module GreinerGens
  class Railtie < Rails::Railtie
    generators do
      require 'generators/slimmer/slimmer_generator'
      require 'generators/simple_css/simple_css_generator'
    end
  end
end