# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/generators/greiner/openapi/openapi_generator'

# fake the call 'Rails.application.class.module_parent_name' which is used by version.rb
module DummyApp
  class Application
    def self.module_parent_name
      "DummyApp"
    end
  end
end

module Rails
  def self.application
    DummyApp::Application.new
  end
end

class OpenapiGeneratorTest < Rails::Generators::TestCase
  tests Greiner::OpenapiGenerator
  destination Rails.root.join('generators-openapi')
  setup :prepare_destination

  test 'generator modifies routes.rb' do
    assert_file 'config/routes.rb' do |content|
      assert_match(/health#/, content)
    end
  end

  test 'generator modifies Gemfile' do
    assert_file 'Gemfile' do |content|
      assert_match(/committee/, content)
    end
  end

  test 'generator adds version.rb' do
    assert_file 'config/version.rb'  
  end

  test 'generator adds two controlelrs' do
    assert_file 'app/controllers/health_controller.rb'
    assert_file 'app/controllers/info_controller.rb'
  end

  def setup
    super
    # Greiner::OpenapiGenerator.define_method(:application) { "Rail" }
    # Rails.application = DummyApp::Application.new
    prepare_fake_rails_app
    run_generator
  end

  def prepare_fake_rails_app
    # Create directory structure
    FileUtils.mkdir_p(File.join(destination_root, 'config'))
    FileUtils.mkdir_p(File.join(destination_root, 'app', 'controllers'))

    # Create fake Gemfile
    File.write(
      File.join(destination_root, 'Gemfile'),
      <<~GEMFILE
        # Fake gemfile
        source "https://rubygems.org"

      GEMFILE
    )
    # Create fake config/application.rb
    File.write(
      File.join(destination_root, 'config/application.rb'),
      <<~APP
        module DumymApp
          class Application < Rails::Application
            config.assets.enabled = true
          end
        end
      APP
    )

    # Create fake routes
    File.write(
      File.join(destination_root, 'config', 'routes.rb'),
      <<~ROUTES
        Rails.application.routes.draw do
          get "up" => "rails/health#show", as: :rails_health_check
        end
      ROUTES
    )

    # Create fake application
    File.write(
      File.join(destination_root, 'config', 'application.rb'),
      <<~APP
        module DummyApp
          class Application 
            config.assets.enabled = true
          end
        end
      APP
    )
  end
end
