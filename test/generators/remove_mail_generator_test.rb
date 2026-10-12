# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/generators/greiner/remove_mail/remove_mail_generator"

class EntraidGeneratorTest < Rails::Generators::TestCase
  tests Greiner::EntraidGenerator
  destination File.expand_path("../../tmp/generators-remove-mail", __dir__)
  setup :prepare_destination
  setup :prepare_fake_rails_app

  test "generator removes gem" do
    run_generator
    assert_file "Gemfile" do |content|
      refute_match(/gem.+?mail/, content)
    end
  end

  private

  def prepare_fake_rails_app
    # Create directory structure
    FileUtils.mkdir_p(File.join(destination_root, "config", "initializers"))

    # Create fake Gemfile
    File.write(
      File.join(destination_root, "Gemfile"),
      <<~GEMFILE
        # Fake gemfile
        source "https://rubygems.org"
        gem "mail"
      GEMFILE
    )

    # Create fake config/application.rb
    File.write(
      File.join(destination_root, "config/application.rb"),
      <<~APP
        module Bla
          class Application < Rails::Application
            config.assets.enabled = true
            require "mail"
            config.autoload_lib
            config.generators.template_engine = :slim
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
