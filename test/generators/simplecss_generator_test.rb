require 'test_helper'
require_relative '../../lib/generators/greiner/simplecss/simplecss_generator'

class SimplecssGeneratorTest < Rails::Generators::TestCase
  tests Greiner::SimplecssGenerator
  destination Rails.root.join('tmp/generators')
  setup :prepare_destination

  test "generator modifies layouts/application.rb" do
    run_generator ["greiner:simplecss"]
    assert_file "app/views/layouts/application.html.erb" do |content|
      assert_match(/grid-template-columns/, content)
      assert_match(/simple\.min\.css/, content)
    end
  end

  def setup
    super
    prepare_fake_rails_app
  end

  def prepare_fake_rails_app
    # Create directory structure
    FileUtils.mkdir_p(File.join(destination_root, 'app/views/layouts'))
    FileUtils.mkdir_p(File.join(destination_root, 'config'))
    
    # Create fake application.html.erb
    File.write(
      File.join(destination_root, 'app/views/layouts/application.html.erb'),
      <<~HTML
        <!DOCTYPE html>
        <html>
          <head>
            <title>MyApp</title>
            <%= stylesheet_link_tag :app, "data-turbo-track": "reload" %>
          </head>
          <body>
            <%= yield %>
          </body>
        </html>
      HTML
    )
  end

end
