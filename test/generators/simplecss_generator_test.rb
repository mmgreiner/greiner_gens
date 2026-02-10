# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/generators/greiner/simplecss/simplecss_generator'

class SimplecssGeneratorTest < Rails::Generators::TestCase
  tests Greiner::SimplecssGenerator
  destination Rails.root.join('generators')
  setup :prepare_destination

  test 'generator modifies layouts/application.rb' do
    run_generator # ['greiner:simplecss']
    assert_file 'app/views/layouts/application.html.erb' do |content|
      assert_match(/grid-template-columns/, content)
      assert_match(/simple\.min\.css/, content)
    end
  end

  test 'generator modifies layouts/application.rb with option --luzern' do
    run_generator ["--luzern"]   # , luzern: true
    logo_file = 'Logo_Kanton_Luzern_RGB.png'
    assert_file 'app/views/layouts/application.html.erb' do |content|
      assert_match(/grid-template-columns/, content)
      assert_match(/simple\.min\.css/, content)
      assert_match(/@media \(prefers-color-scheme: dark\)/, content)
      assert_match(logo_file, content)
    end
    assert_file "public/#{logo_file}"
  end

  def setup
    super
    prepare_fake_rails_app
  end

  def prepare_fake_rails_app
    # Create directory structure
    FileUtils.mkdir_p(File.join(destination_root, 'app/views/layouts'))
    FileUtils.mkdir_p(File.join(destination_root, 'config'))
    FileUtils.mkdir_p(File.join(destination_root, 'public'))

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
