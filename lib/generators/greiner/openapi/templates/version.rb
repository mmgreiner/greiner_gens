module <%= Rails.application.class.module_parent_name %>
  # added by 'rails generate greiner:openapi'
  VERSION = if ENV["APP_VERSION"].present?
              ENV["APP_VERSION"]
            elsif File.exist?(File.expand_path("../.git", __dir__)))
              `git describe --tags --dirty --always`.strip
            else
              "unknown"
            end
end
