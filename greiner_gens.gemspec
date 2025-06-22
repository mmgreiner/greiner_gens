# frozen_string_literal: true

require_relative "lib/greiner_gens/version"

Gem::Specification.new do |spec|
  spec.name = "greiner_gens"
  spec.version = GreinerGens::VERSION
  spec.authors = ["mmgreiner"]
  spec.email = ["mmgreiner@bluewin.ch"]

  spec.summary = "Provides two simple generators for slim and simple.css."
  spec.description = <<~DESC 
    Provides two generators for a rails project: slimmer adds slim to a"
    - slimmer adds the slim-rails gem and adjusts configuration accordingly
    - simple_css sets application.html.erb up to use the simple.css templating framework 
  DESC
  spec.homepage = "https://github.com/mmgreiner"
  spec.required_ruby_version = ">= 3.1.0"
  spec.licenses = "MIT"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/mmgreiner"
  spec.metadata["changelog_uri"] = "https://github.com/mmgreiner"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
