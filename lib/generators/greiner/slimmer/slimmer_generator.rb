module Greiner
  class SlimmerGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    desc "Add slim-rails gem and configure Rails to use Slim"

    def add_slim_gem
      gem 'slim-rails', group: :development
      run 'bundle install'
    end

    def configure_slim
      # gsub_file 'config/application.rb', '# config.generators.template_engine = :erb', '  config.generators.template_engine = :slim'
      inject_into_file 'config/application.rb', "    config.generators.template_engine = :slim\n", before: "  end"
    end
  end
end