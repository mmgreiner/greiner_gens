require 'bundler/setup'
require 'minitest/autorun'
require 'rails/generators'
require 'rails/generators/test_case'

# Require your generator
require_relative '../lib/generators/greiner/simplecss/simplecss_generator'
require_relative '../lib/generators/greiner/slim/slim_generator'

$VERBOSE = nil

# Set up a fake Rails root for testing
module Rails
  def self.root
    Pathname.new(File.expand_path('../tmp', __dir__))
  end
end