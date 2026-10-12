# frozen_string_literal: true

module Greiner
  # Rails generator to provide additional rake tasks to destroy mail
  class RemoveMailGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    desc 'Remove mail gem'
    def remove_mail_gem
      gsub_file 'Gemfile', /gem.+?mail\W*$/, ""
      run 'bundle install'
    end

    desc "Remove references to mail from config"
    def remove_from_config
      # # require "action_mailer/railtie"
      # require "action_mailbox/engine"
      config_file = "config/application.rb"
      gsub config_file, /^\s*require.+?mail.*$/, ""
      replacement = "    config.action_mailer.perform_deliveries = false\n"
      inject_into_file config_file, replacement, after: /config\.autoload_lib.*\n/
    end

    desc "Delete mailer files"
    def delete_mailer_files
      # gsub_file 'config/application.rb', '# config.generators.template_engine = :erb', '  config.generators.template_engine = :slim'
      lines = <<~SLIM.indent(4)
        # use slim templating
        config.generators.template_engine = :slim

      SLIM
      inject_into_file "config/application.rb", lines, before: "  end"
    end
  end
end
