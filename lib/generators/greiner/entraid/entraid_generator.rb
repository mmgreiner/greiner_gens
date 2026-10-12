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
      bundle_command("install") unless options[:skip_bundle]
    end

    def add_middleware
      copy_file "entra.rb.tt", "config/initializers/entra.rb"
    end

    def create_migration_file
      migration_template(
        "add_entra_to_users.rb.tt",
        File.join("db/migrate", "add_entra_to_users.rb"),
        migration_version: migration_version
      )
    end

    def add_routes
      route 'get "/auth/:provider/callback", to: "omniauth_callbacks#create"'
      route 'get "/auth/failure", to: "omniauth_callbacks#failure"'
    end

    def change_dotenv
      envs = <<~ENVS
        ENTRA_TENANT_ID=
        ENTRA_CLIENT_ID=
        ENTRA_CLIENT_SECRET=
        # not really used
        ENTRA_CLIENT_SECRET_ID=
      ENVS

      env_path = File.join(destination_root, ".env")

      if behavior == :revoke
        # remove only our block; keep the user's .env
        gsub_file ".env", envs, "" if File.exist?(env_path)
      else
        create_file ".env", "", skip: true
        append_to_file ".env", envs unless File.exist?(env_path) && File.read(env_path).include?("ENTRA_TENANT_ID=")
      end
    end

    VIEW_BASE = "app/views/sessions/new.html"

    def add_login_button
      ext = %w[erb slim].find { |e| File.exist?(File.join(destination_root, "#{VIEW_BASE}.#{e}")) }

      unless ext
        say_status :skip, "no #{VIEW_BASE}.erb or .slim found", :yellow
        return
      end

      path = "#{VIEW_BASE}.#{ext}"
      return if File.read(File.join(destination_root, path)).include?("auth/entra_id")

      snippet = (ext == "slim") ? slim_button : erb_button
      append_to_file path, snippet
    end

    private

    def erb_button
      <<~ERB

        <%= button_to "Sign in with Microsoft", "/auth/entra_id", method: :post %>
      ERB
    end

    def slim_button
      <<~SLIM

        = button_to "Sign in with Microsoft", "/auth/entra_id", method: :post
      SLIM
    end

    def migration_version
      "[#{ActiveRecord::Migration.current_version}]"
    end
  end
end
