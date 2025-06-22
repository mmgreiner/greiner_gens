# frozen_string_literal: true

require_relative "greiner_gens/version"
require_relative "greiner_gens/railtie" if defined?(Rails)

module GreinerGens
  class Error < StandardError; end
  # Your code goes here...
end
