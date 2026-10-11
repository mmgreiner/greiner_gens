# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/generators/greiner/entraid/entraid_generator"

class EntraidGeneratorTest < Rails::Generators::TestCase
  tests Greiner::EntraidGenerator
  destination File.expand_path("../../tmp/generators-entraid", __dir__)
  setup :prepare_destination
  setup :prepare_fake_rails_app
  puts "🤖 destination: #{destination_root}"

  test "generator adds config/entra.rb" do
    run_generator
    assert_file "config/initializers/entra.rb"
    # assert_file 'config/application.rb' do |content|
    #   assert_match(/config.generators.template_engine = :slim/, content)
    # end
  end

  test "generator adds routes" do
    run_generator
    assert_file "config/routes.rb" do |content|
      assert_match(/omniauth_call/, content)
    end
  end

  test "generator adds env" do
    run_generator
    assert_file ".env" do |content|
      assert_match(/^ENTRA_(CLIENT|TENANT)/, content)
    end
  end

  private

  def prepare_fake_rails_app
    # Create directory structure
    FileUtils.mkdir_p(File.join(destination_root, 'config', 'initializers'))

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
        module Bla
          class Application < Rails::Application
            config.assets.enabled = true
          end
        end
      APP
    )

    # create fake routes file config/routes.rb
    File.write(
      File.join(destination_root, "config", "routes.rb"),
      <<~CODE
        Rails.application.routes.draw do
        end
      CODE
    )
  end
end
