# frozen_string_literal: true

module Greiner
  # Rails generator to add simplecss css framework to a rails application
  class SimplecssGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)
    class_option :luzern, type: :boolean, default: false, desc: 'Use Kanton Luzern theme and logo'

    desc 'Add the simplecss framework and adjusts application.html.erb accordingly'

    def configure_simplecss
      style =
        <<~STYLE.indent(4)

          <%= stylesheet_link_tag "https://cdn.simplecss.org/simple.min.css" %>
          <style>
            :root {
              --reading-width: min(45rem, 90%);
            }
            body {
              grid-template-columns: 1fr 98% 1fr;
            }
          </style>
        STYLE

      # for luzern, use a different dark style and size the logo
      luzern = <<~LUZERN.indent(4)

        <style>
          .logo {
            width: 150px;
            height: auto;
            margin-right: 20px;
          }
          @media (prefers-color-scheme: dark) {
            :root {
              --accent: #009fe3; /* #ffb300; */
              --accent-hover: #94bed4; /* #ffe099; */
              --code: #def0fa; /* #f06292; */
              --preformatted: #ccc;
              --disabled: #111;
            }
          }
        </style>
      LUZERN

      # add the additional stylesheet link
      app_file = 'app/views/layouts/application.html.erb'
      inject_into_file app_file, style, after: /^.+stylesheet_link_tag.+$/
      inject_into_file app_file, luzern, after: %r{</style>} if options[:luzern]

      # replace the simple yield with header, navigation, main and footer
      gsub_file app_file,
                '    <%= yield %>',
                <<~BODY.indent(4)
                  <header>
                    <nav>
                      <ul>
                        <li><%= link_to :home, root_path %>
                      </ul>
                    </nav>
                  </header>
                  <main>
                    <%= yield %>
                  </main>
                  <footer>
                    Copyright &copy; <%= Date.today.year %> <my company>
                  </footer>
                BODY
      return unless options[:luzern]

      logo_file = 'Logo_Kanton_Luzern_RGB.png'
      li = "\n          <li><img src=\"/#{logo_file}\" alt=\"Luzern Logo\" class=\"logo\" ></li>"
      inject_into_file app_file, li, after: /<ul>/
      copy_file logo_file, "public/#{logo_file}"
    end
  end
end
