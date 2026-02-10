# frozen_string_literal: true

module Greiner
  # Rails generator to change everything to use slim templating
  class SlimGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    desc 'Add slim-rails gem and configure Rails to use Slim'

    def add_slim_gem
      gem 'slim-rails'
      run 'bundle install'
    end

    def configure_slim
      # gsub_file 'config/application.rb', '# config.generators.template_engine = :erb', '  config.generators.template_engine = :slim'
      lines = <<~SLIM.indent(4)
        # use slim templating
        config.generators.template_engine = :slim

      SLIM
      inject_into_file 'config/application.rb', "#{lines}\n", before: '  end'
    end
  end
end
