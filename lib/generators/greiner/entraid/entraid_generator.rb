# frozen_string_literal: true

require "rails/generators"
require "rails/generators/active_record"

module Greiner
  # Rails generator to change everything to use slim templating
  class EntraidGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    # Required: tells Rails how to generate the timestamp/number
    def self.next_migration_number(dirname)
      ActiveRecord::Generators::Base.next_migration_number(dirname)
    end

    source_root File.expand_path("templates", __dir__)

    desc "Add EntraID Sign-on to a Rails 8 app with authentication"

    def add_omniauth_gems
      gem "omniauth"
      gem "omniauth_openid_connect"
      gem "omniauth-rails_csrf_protection"
      run "bundle update"
    end

    def add_middleware
      copy_file "entra.rb", "config/initializers/entra.rb"
    end

    def create_migration_file
      migration_template(
        "add_entra_to_users.rb.tt",
        File.join("db/migrate", "add_entra_to_users.rb"),
        migration_version: migration_version
      )
    end

    def add_routes
      routes = <<~ROUTES
        get "/auth/:provider/callback", to: "omniauth_callbacks#create"
        get "/auth/failure", to: "omniauth_callbacks#failure"
      ROUTES
      inject_into_file "config/routes.rb", routes, before: /^end/
    end

    def change_dotenv
      envs = <<~ENVS
        ENTRA_TENANT_ID=
        ENTRA_CLIENT_ID=
        ENTRA_CLIENT_SECRET=
        # not really used
        ENTRA_CLIENT_SECRET_ID=
      ENVS
      create_file ".env", "# ENTRA_ID variables\n", skip: true
      append_to_file ".env", envs
    end

    private

    def migration_version
      "[#{ActiveRecord::Migration.current_version}]"
    end
  end
end
