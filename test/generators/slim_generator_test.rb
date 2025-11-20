require 'test_helper'
require_relative '../../lib/generators/greiner/slim/slim_generator'

class SlimGeneratorTest < Rails::Generators::TestCase
  tests Greiner::SlimGenerator
  destination Rails.root.join('tmp/generators')
  setup :prepare_destination

  test "generator modifies config/application.rb" do
    run_generator ["greiner:slim"]
    assert_file "config/application.rb" do |content|
      assert_match(/config.generators.template_engine = :slim/, content)
    end
  end

  def setup
    super
    prepare_fake_rails_app
  end

  def prepare_fake_rails_app
    # Create directory structure
    FileUtils.mkdir_p(File.join(destination_root, 'config'))
    
    # Create fake Gemfile
    File.write(
      File.join(destination_root, "Gemfile"),
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
  end

end
